import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'legal_call_dialog.dart';
import 'legal_case_detail_dialog.dart';

/// Componente modular de Mapa Interactivo para el Centro de Mando Jurídico.
/// Muestra en tiempo real incidentes viales clasificados por triage,
/// unidades móviles de abogados en territorio y rutas activas de despacho con ETA.
class LegalDispatchMap extends StatefulWidget {
  final bool isFullScreen;
  final VoidCallback? onToggleFullScreen;

  const LegalDispatchMap({
    super.key,
    this.isFullScreen = false,
    this.onToggleFullScreen,
  });

  @override
  State<LegalDispatchMap> createState() => _LegalDispatchMapState();
}

class _LegalDispatchMapState extends State<LegalDispatchMap>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Centro por defecto: Imbabura (Otavalo - Ibarra)
  static const LatLng _defaultCenter = LatLng(0.2450, -78.2500);
  static const double _defaultZoom = 12.6;

  int _lastHandledMoveCounter = -1;
  bool _cardMinimized = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Animación de pulso para incidentes críticos y alertas en vivo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Animación fluida de cámara hacia coordenadas de destino
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: destZoom,
    );

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    );

    animationController.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        // Sincronización de movimiento de cámara si el controller lo solicitó
        if (controller.mapMoveCounter != _lastHandledMoveCounter &&
            controller.targetMapLat != null &&
            controller.targetMapLng != null) {
          _lastHandledMoveCounter = controller.mapMoveCounter;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _animatedMapMove(
              LatLng(controller.targetMapLat!, controller.targetMapLng!),
              controller.targetMapZoom,
            );
          });
        }

        final selectedCase = controller.selectedCase;
        final selectedLawyer = controller.selectedLawyer;
        final assignedLawyer = selectedCase != null
            ? controller.getAssignedLawyerForCase(selectedCase)
            : null;

        final screenWidth = MediaQuery.of(context).size.width;
        final isMobileMap = screenWidth < 600;

        return ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // MAPA INTERACTIVO OPENSTREETMAP
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: _defaultCenter,
                    initialZoom: _defaultZoom,
                    minZoom: 6.0,
                    maxZoom: 18.0,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    // Capa de mosaicos OpenStreetMap
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'ec.legaltech.asistencia_legal_web',
                    ),

                    // Capa de Polilínea de Despacho (Ruta Abogado -> Incidente)
                    if (controller.showRoutesLayer &&
                        selectedCase != null &&
                        assignedLawyer != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              LatLng(assignedLawyer.lat, assignedLawyer.lng),
                              LatLng(selectedCase.lat, selectedCase.lng),
                            ],
                            strokeWidth: 3.8,
                            color: const Color(0xFF0D47A1),
                            pattern: StrokePattern.dashed(
                              segments: const [10, 6],
                            ),
                          ),
                        ],
                      ),

                    // Capa de Marcadores (Taxis, Abogados y Etiqueta ETA)
                    MarkerLayer(
                      markers: [
                        // 1. Taxis con Incidentes
                        if (controller.showIncidentsLayer)
                          ...controller.filteredCases.map(
                            (c) => _buildIncidentMarker(controller, c),
                          ),

                        // 2. Abogados de Territorio (Unidades Móviles)
                        if (controller.showLawyersLayer)
                          ...controller.territoryLawyers.map(
                            (l) => _buildLawyerMarker(controller, l),
                          ),

                        // 3. Etiqueta flotante de ETA en el punto medio de la ruta
                        if (controller.showRoutesLayer &&
                            selectedCase != null &&
                            assignedLawyer != null)
                          _buildEtaMarker(controller, selectedCase, assignedLawyer),
                      ],
                    ),
                  ],
                ),

                // BARRA SUPERIOR DE HERRAMIENTAS Y CONTROL DE CAPAS
                Positioned(
                  top: isMobileMap ? 8 : 12,
                  left: isMobileMap ? 8 : 12,
                  right: isMobileMap ? 8 : 12,
                  child: _buildTopControlBar(context, controller, isMobileMap),
                ),

                // CONTROLES DE ZOOM FLOTANTES (En móviles arriba a la derecha para no chocar con cards)
                Positioned(
                  right: isMobileMap ? 8 : 14,
                  top: isMobileMap ? 56 : null,
                  bottom: isMobileMap
                      ? null
                      : (selectedCase != null && !_cardMinimized ? 230 : 54),
                  child: _buildFloatingMapControls(context, controller),
                ),

                // LEYENDA DISCRETA INFERIOR (Oculta en móvil si la card está abierta)
                if (!isMobileMap || (selectedCase == null && selectedLawyer == null) || _cardMinimized)
                  Positioned(
                    left: isMobileMap ? 8 : 14,
                    bottom: isMobileMap ? 8 : 12,
                    child: _buildLegendBar(context, controller),
                  ),

                // CARD EMERGENTE FLOTANTE: DETALLE DEL INCIDENTE SELECCIONADO
                if (selectedCase != null)
                  Positioned(
                    left: isMobileMap ? 8 : 14,
                    right: isMobileMap ? 8 : 14,
                    bottom: isMobileMap ? 8 : 46,
                    child: _buildSelectedCaseCard(
                      context,
                      controller,
                      selectedCase,
                      assignedLawyer,
                      isMobileMap,
                    ),
                  )
                else if (selectedLawyer != null)
                  // CARD EMERGENTE FLOTANTE: DETALLE DEL ABOGADO SELECCIONADO
                  Positioned(
                    left: isMobileMap ? 8 : 14,
                    right: isMobileMap ? 8 : 14,
                    bottom: isMobileMap ? 8 : 46,
                    child: _buildSelectedLawyerCard(
                      context,
                      controller,
                      selectedLawyer,
                      isMobileMap,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- MARCADOR: TAXI CON INCIDENTE ---
  Marker _buildIncidentMarker(LegalCenterController controller, LegalCase c) {
    final isSelected = controller.selectedCase?.id == c.id;
    final isLastAlert = controller.lastAlertedCaseId == c.id;
    final alertColor = c.alertaNivel.color;

    return Marker(
      point: LatLng(c.lat, c.lng),
      width: isSelected ? 120 : 90,
      height: isSelected ? 90 : 70,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _cardMinimized = false;
          });
          controller.selectCase(c, moveMap: false);
        },
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final pulseScale = isLastAlert || isSelected
                ? 1.0 + (_pulseAnimation.value * 0.12)
                : 1.0;

            return Transform.scale(
              scale: pulseScale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono Pin de Incidente
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Halo pulsante exterior si es crítico o recién alertado
                      if (isSelected || isLastAlert)
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: alertColor.withValues(
                              alpha: 0.25 + (_pulseAnimation.value * 0.2),
                            ),
                          ),
                        ),

                      // Pin Principal
                      Container(
                        width: isSelected ? 36 : 30,
                        height: isSelected ? 36 : 30,
                        decoration: BoxDecoration(
                          color: alertColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: isSelected ? 2.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: alertColor.withValues(alpha: 0.5),
                              blurRadius: isSelected ? 10 : 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          c.tieneHeridosORetencion
                              ? Icons.emergency_rounded
                              : Icons.car_crash_rounded,
                          color: Colors.white,
                          size: isSelected ? 20 : 16,
                        ),
                      ),

                      // Badge de alerta crítica "SOS"
                      if (isLastAlert)
                        Positioned(
                          top: -2,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1744),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              'SOS',
                              style: ubuntuBold.copyWith(
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Chip con Placa y Unidad
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A237E)
                          : Colors.black.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.white24,
                        width: isSelected ? 1.2 : 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${c.placa} • ${c.unidad.replaceAll('Unidad ', '#')}',
                      style: ubuntuBold.copyWith(
                        fontSize: isSelected ? 9.5 : 8.5,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- MARCADOR: ABOGADO DE TERRITORIO (UNIDAD MÓVIL) ---
  Marker _buildLawyerMarker(
    LegalCenterController controller,
    TerritoryLawyer lawyer,
  ) {
    final isSelected = controller.selectedLawyer?.id == lawyer.id;
    final isOnline = lawyer.estadoGuardia == LawyerGuardStatus.enLinea;
    final badgeColor = isOnline
        ? const Color(0xFF2E7D32)
        : const Color(0xFFF57C00);

    return Marker(
      point: LatLng(lawyer.lat, lawyer.lng),
      width: 110,
      height: 68,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _cardMinimized = false;
          });
          controller.selectLawyer(lawyer);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isSelected ? 34 : 28,
              height: isSelected ? 34 : 28,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 2.5 : 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withValues(alpha: 0.45),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: isSelected ? 18 : 15,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.lightGreenAccent : Colors.white24,
                  width: 1,
                ),
              ),
              child: Text(
                '${lawyer.nombre.split(' ').first} (${lawyer.canton})',
                style: ubuntuBold.copyWith(
                  fontSize: 8.5,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- MARCADOR: ETIQUETA ETA EN RUTA ---
  Marker _buildEtaMarker(
    LegalCenterController controller,
    LegalCase caseItem,
    TerritoryLawyer lawyer,
  ) {
    // Coordenada en el punto medio exacto
    final midLat = (lawyer.lat + caseItem.lat) / 2;
    final midLng = (lawyer.lng + caseItem.lng) / 2;

    final distKm = controller.calculateDistanceKm(
      caseItem.lat,
      caseItem.lng,
      lawyer.lat,
      lawyer.lng,
    );
    final etaMinutes = ((distKm / 35.0) * 60 + 3).round().clamp(4, 25);

    return Marker(
      point: LatLng(midLat, midLng),
      width: 155,
      height: 38,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF64B5F6), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, color: Colors.amber, size: 14),
            const SizedBox(width: 4),
            Text(
              'ETA: $etaMinutes min • ${distKm.toStringAsFixed(1)} km',
              style: ubuntuBold.copyWith(
                fontSize: 10,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BARRA SUPERIOR DE HERRAMIENTAS Y FILTROS DE CAPAS ---
  Widget _buildTopControlBar(
    BuildContext context,
    LegalCenterController controller,
    bool isMobileMap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobileMap ? 6 : 10,
        vertical: isMobileMap ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E293B) : Colors.white)
            .withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Indicador de estado GPS / OSM
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF00E676),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isMobileMap ? 'GPS' : 'Despacho Táctico',
            style: ubuntuBold.copyWith(
              fontSize: isMobileMap ? 10.5 : Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 6),

          // Chips de Toggles de Capas con scroll horizontal suave
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _layerToggleChip(
                    context: context,
                    label: isMobileMap
                        ? 'Taxis (${controller.filteredCases.length})'
                        : 'Taxis (${controller.filteredCases.length})',
                    icon: Icons.local_taxi_rounded,
                    isActive: controller.showIncidentsLayer,
                    activeColor: const Color(0xFFD32F2F),
                    isCompact: isMobileMap,
                    onTap: controller.toggleIncidentsLayer,
                  ),
                  const SizedBox(width: 4),
                  _layerToggleChip(
                    context: context,
                    label: isMobileMap
                        ? 'Abogados (${controller.territoryLawyers.length})'
                        : 'Abogados (${controller.territoryLawyers.length})',
                    icon: Icons.shield_rounded,
                    isActive: controller.showLawyersLayer,
                    activeColor: const Color(0xFF2E7D32),
                    isCompact: isMobileMap,
                    onTap: controller.toggleLawyersLayer,
                  ),
                  const SizedBox(width: 4),
                  _layerToggleChip(
                    context: context,
                    label: isMobileMap ? 'Rutas' : 'Rutas & ETA',
                    icon: Icons.alt_route_rounded,
                    isActive: controller.showRoutesLayer,
                    activeColor: const Color(0xFF0D47A1),
                    isCompact: isMobileMap,
                    onTap: controller.toggleRoutesLayer,
                  ),
                ],
              ),
            ),
          ),

          // Botón recentrar vista
          IconButton(
            tooltip: 'Recentrar vista general',
            icon: Icon(Icons.my_location_rounded, size: isMobileMap ? 15 : 18),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: isMobileMap ? 26 : 32,
              minHeight: isMobileMap ? 26 : 32,
            ),
            onPressed: () {
              controller.resetMapToDefaultBounds();
            },
          ),

          // Botón de pantalla completa si está disponible
          if (widget.onToggleFullScreen != null) ...[
            IconButton(
              tooltip: widget.isFullScreen
                  ? 'Reducir tamaño'
                  : 'Ampliar mapa completo',
              icon: Icon(
                widget.isFullScreen
                    ? Icons.fullscreen_exit_rounded
                    : Icons.fullscreen_rounded,
                size: isMobileMap ? 17 : 20,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: isMobileMap ? 26 : 32,
                minHeight: isMobileMap ? 26 : 32,
              ),
              onPressed: widget.onToggleFullScreen,
            ),
          ],
        ],
      ),
    );
  }

  Widget _layerToggleChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 6 : 8,
          vertical: isCompact ? 2 : 3,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.12)
              : Colors.grey.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? activeColor : Colors.grey.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isCompact ? 11 : 12,
              color: isActive ? activeColor : Colors.grey.shade600,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: ubuntuBold.copyWith(
                fontSize: isCompact ? 9 : 10,
                color: isActive
                    ? activeColor
                    : Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CONTROLES FLOTANTES DE ZOOM Y CENTRADO ---
  Widget _buildFloatingMapControls(
    BuildContext context,
    LegalCenterController controller,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _mapActionButton(
          icon: Icons.add,
          tooltip: 'Acercar zoom',
          onPressed: () {
            _animatedMapMove(
              _mapController.camera.center,
              math.min(18.0, _mapController.camera.zoom + 1.0),
            );
          },
        ),
        const SizedBox(height: 6),
        _mapActionButton(
          icon: Icons.remove,
          tooltip: 'Alejar zoom',
          onPressed: () {
            _animatedMapMove(
              _mapController.camera.center,
              math.max(6.0, _mapController.camera.zoom - 1.0),
            );
          },
        ),
      ],
    );
  }

  Widget _mapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: Colors.blueGrey.shade900),
        tooltip: tooltip,
        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  // --- LEYENDA DISCRETA INFERIOR ---
  Widget _buildLegendBar(
    BuildContext context,
    LegalCenterController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendItem(const Color(0xFFD32F2F), 'Código Rojo'),
          const SizedBox(width: 8),
          _legendItem(const Color(0xFFF57C00), 'Choque Regular'),
          const SizedBox(width: 8),
          _legendItem(const Color(0xFF2E7D32), 'Abogado Móvil'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: ubuntuRegular.copyWith(
            fontSize: 9,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  // --- CARD EMERGENTE FLOTANTE: DETALLE DEL INCIDENTE SELECCIONADO ---
  Widget _buildSelectedCaseCard(
    BuildContext context,
    LegalCenterController controller,
    LegalCase caseItem,
    TerritoryLawyer? assignedLawyer,
    bool isMobileMap,
  ) {
    final alert = caseItem.alertaNivel;

    if (_cardMinimized) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: alert.color, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(alert.icon, size: 14, color: alert.color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '${caseItem.id} • ${caseItem.taxistaNombre}',
                  style: ubuntuBold.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _cardMinimized = false),
                child: const Icon(Icons.expand_less_rounded, size: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: 420,
        maxHeight: isMobileMap ? 200 : 310,
      ),
      padding: EdgeInsets.all(isMobileMap ? 10 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: alert.color.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: alert.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: alert.color),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(alert.icon, size: 11, color: alert.color),
                          const SizedBox(width: 3),
                          Text(
                            alert.label,
                            style: ubuntuBold.copyWith(
                              fontSize: 9.5,
                              color: alert.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${caseItem.id} • ${caseItem.placa}',
                        style: ubuntuBold.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => setState(() => _cardMinimized = true),
                    child: Icon(
                      Icons.expand_more_rounded,
                      size: 18,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => controller.selectCase(caseItem, moveMap: false),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Cuerpo de la tarjeta con scroll seguro para pantallas cortas
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conductor y Unidad
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${caseItem.taxistaNombre} • ${caseItem.unidad} (${caseItem.cooperativa})',
                          style: ubuntuBold.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          caseItem.ubicacionDireccion,
                          style: ubuntuRegular.copyWith(
                            fontSize: 10,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Dictamen IA breve
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF0D47A1).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          size: 12,
                          color: Color(0xFF0D47A1),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            caseItem.shortDictamenSummary,
                            style: ubuntuRegular.copyWith(
                              fontSize: 9.5,
                              color: const Color(0xFF0D47A1),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Estado del Abogado Asignado
                  Row(
                    children: [
                      Icon(
                        assignedLawyer != null
                            ? Icons.verified_user_rounded
                            : Icons.person_search_rounded,
                        size: 13,
                        color: assignedLawyer != null
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          caseItem.abogadoAsignado != null
                              ? 'Abogado: ${caseItem.abogadoAsignado} (${caseItem.horaDespacho ?? "En camino"})'
                              : 'Sin abogado asignado',
                          style: ubuntuBold.copyWith(
                            fontSize: 10,
                            color: assignedLawyer != null
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (assignedLawyer == null)
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => controller.autoDispatchCase(caseItem),
                          child: Text(
                            '⚡ Despachar',
                            style: ubuntuBold.copyWith(fontSize: 9.5),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Botones de Acción (Llamada + Expediente 360°)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 12),
                  label: Text(
                    isMobileMap ? 'Llamar' : 'Llamar Conductor',
                    style: ubuntuBold.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () => LegalCallDialog.show(context, caseItem),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.folder_shared_outlined, size: 12),
                  label: Text(
                    isMobileMap ? 'Expediente' : 'Expediente 360°',
                    style: ubuntuBold.copyWith(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () => LegalCaseDetailDialog.show(context, caseItem),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- CARD EMERGENTE FLOTANTE: DETALLE DEL ABOGADO SELECCIONADO ---
  Widget _buildSelectedLawyerCard(
    BuildContext context,
    LegalCenterController controller,
    TerritoryLawyer lawyer,
    bool isMobileMap,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 380,
        maxHeight: isMobileMap ? 180 : 250,
      ),
      padding: EdgeInsets.all(isMobileMap ? 10 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: lawyer.estadoColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: lawyer.estadoBgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: lawyer.estadoColor),
                      ),
                      child: Text(
                        lawyer.estadoLabel,
                        style: ubuntuBold.copyWith(
                          fontSize: 9.5,
                          color: lawyer.estadoColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        lawyer.nombre,
                        style: ubuntuBold.copyWith(fontSize: 11.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => controller.selectLawyer(null),
                child: const Icon(Icons.close, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${lawyer.unidadMovil} • ${lawyer.canton}, ${lawyer.provincia}',
                    style: ubuntuRegular.copyWith(
                      fontSize: 10.5,
                      color: Theme.of(context).hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Especialidad: ${lawyer.especialidad}',
                    style: ubuntuRegular.copyWith(fontSize: 10),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${lawyer.casosActivos} activos • ${lawyer.porcentajeCumplimiento}% éxito',
                  style: ubuntuBold.copyWith(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: const Icon(Icons.phone_rounded, size: 11),
                label: Text(
                  lawyer.telefono,
                  style: ubuntuBold.copyWith(fontSize: 9.5),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
