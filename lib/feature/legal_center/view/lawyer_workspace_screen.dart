import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/model/legal_case_model.dart';
import 'package:getdash/feature/legal_center/widgets/expediente_360_panel.dart';
import 'package:getdash/feature/legal_center/widgets/legal_mobile_nav_header.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

/// Espacio de trabajo exclusivo para el Abogado Asociado / De Turno en Territorio.
/// Optimizado prioritariamente para dispositivos móviles con alta usabilidad táctil.
class LawyerWorkspaceScreen extends StatefulWidget {
  const LawyerWorkspaceScreen({super.key});

  @override
  State<LawyerWorkspaceScreen> createState() => _LawyerWorkspaceScreenState();
}

class _LawyerWorkspaceScreenState extends State<LawyerWorkspaceScreen> {
  late final LegalCenterController _legalController;

  // Filtro de estado para "Mis Casos": 0=Todos, 1=En Camino, 2=En Audiencia, 3=Finalizados
  int _selectedStatusFilter = 0;

  @override
  void initState() {
    super.initState();
    _legalController = Get.isRegistered<LegalCenterController>()
        ? Get.find<LegalCenterController>()
        : Get.put(LegalCenterController());
  }

  List<LegalCase> _getFilteredMyCases() {
    final myCases = _legalController.myAssignedCases;
    switch (_selectedStatusFilter) {
      case 1: // En Camino
        return myCases
            .where((c) => c.estado == CaseStatus.abogadoDespachado)
            .toList();
      case 2: // En Audiencia / Trámite
        return myCases
            .where((c) =>
                c.estado == CaseStatus.dictamenAprobado ||
                c.estado == CaseStatus.pendiente)
            .toList();
      case 3: // Finalizados
        return myCases
            .where((c) => c.estado == CaseStatus.atendido)
            .toList();
      default:
        return myCases;
    }
  }

  Future<void> _openNavigation(double lat, double lng) async {
    HapticFeedback.mediumImpact();
    final url =
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar(
        'Navegación GPS',
        'No se pudo abrir la app de mapas externa. Coordenadas: $lat, $lng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E293B),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _callDriver(String phone) async {
    HapticFeedback.lightImpact();
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar(
        'Llamada Telefónica',
        'Llamando a: $cleanPhone',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D47A1),
        colorText: Colors.white,
      );
    }
  }

  void _showExpedienteModal(BuildContext context, LegalCase c) {
    HapticFeedback.mediumImpact();
    final isMobile = ResponsiveHelper.isMobile(context);

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.50,
          maxChildSize: 0.96,
          builder: (sheetContext, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 8),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF0D47A1).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.folder_shared_rounded,
                          color: Color(0xFF1D4ED8),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expediente 360° • ${c.id}",
                              style: ubuntuBold.copyWith(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${c.cooperativa} · Unidad ${c.unidad}",
                              style: ubuntuRegular.copyWith(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(14),
                    child: Expediente360Panel(caseItem: c),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    // Modo Escritorio / Web
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 760,
          height: 650,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(Dimensions.radiusDefault)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.folder_shared_rounded,
                        color: Color(0xFF1D4ED8)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Expediente Digital 360° • ${c.id} (${c.cooperativa})",
                        style: ubuntuBold.copyWith(fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Expediente360Panel(caseItem: c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // ==========================================
    // MODO MÓVIL (PRIORIDAD PRINCIPAL DE INTERFAZ)
    // ==========================================
    if (isMobile) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const LegalMobileNavHeader(
          activeIndex: 0,
          title: "Mi Despacho",
          subtitle: "Espacio de trabajo del abogado de turno",
        ),
        body: GetBuilder<LegalCenterController>(
          builder: (ctrl) {
            return GetBuilder<AuthMockController>(
              builder: (auth) {
                final activeCase = ctrl.myActiveAssignedCase;
                final myCases = _getFilteredMyCases();

                return RefreshIndicator(
                  color: const Color(0xFF1D4ED8),
                  onRefresh: () async {
                    HapticFeedback.lightImpact();
                    ctrl.update();
                    await Future.delayed(const Duration(milliseconds: 350));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. HEADER DE ESTADO OPERATIVO & GUARDIA
                        _buildLawyerProfileCard(context, auth, isMobile),

                        const SizedBox(height: 14),

                        // 2. TARJETA DE ASIGNACIÓN ACTIVA (CÓDIGO ROJO / EN CAMINO)
                        _buildActiveCaseBanner(context, activeCase, isMobile),

                        const SizedBox(height: 18),

                        // 3. SECCIÓN: MIS CASOS ASIGNADOS
                        _buildMyCasesSection(
                            context, ctrl, myCases, isMobile),

                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    // ==========================================
    // MODO ESCRITORIO / WEB (FALLBACK RESPONSIVO)
    // ==========================================
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ResponsiveHelper.isDesktop(context)) const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: GetBuilder<LegalCenterController>(
                      builder: (ctrl) {
                        return GetBuilder<AuthMockController>(
                          builder: (auth) {
                            final activeCase = ctrl.myActiveAssignedCase;
                            final myCases = _getFilteredMyCases();

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeExtraLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLawyerProfileCard(
                                      context, auth, false),
                                  const SizedBox(height: 16),
                                  _buildActiveCaseBanner(
                                      context, activeCase, false),
                                  const SizedBox(height: 20),
                                  _buildMyCasesSection(
                                      context, ctrl, myCases, false),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. HEADER DE ESTADO OPERATIVO ---
  Widget _buildLawyerProfileCard(
    BuildContext context,
    AuthMockController auth,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAvailable = auth.user.isAvailable;

    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        border: Border.all(
          color: isAvailable
              ? const Color(0xFF10B981).withValues(alpha: 0.35)
              : const Color(0xFFEF4444).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAvailable ? const Color(0xFF10B981) : Colors.black)
                .withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar con indicador de guardia
              Stack(
                children: [
                  CircleAvatar(
                    radius: isMobile ? 24 : 28,
                    backgroundColor:
                        const Color(0xFF1D4ED8).withValues(alpha: 0.15),
                    child: Text(
                      auth.user.name.isNotEmpty
                          ? auth.user.name
                              .split(' ')
                              .map((w) => w.isNotEmpty ? w[0] : '')
                              .take(2)
                              .join()
                          : 'AB',
                      style: ubuntuBold.copyWith(
                        color: const Color(0xFF1D4ED8),
                        fontSize: isMobile ? 15 : 18,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.cardColor, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Datos del abogado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            auth.user.name,
                            style: ubuntuBold.copyWith(
                              fontSize: isMobile ? 15 : 17,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D4ED8)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Asociada",
                            style: ubuntuMedium.copyWith(
                              fontSize: 10,
                              color: const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "Jurisdicción: ${auth.user.canton ?? 'Ibarra'} · Imbabura",
                            style: ubuntuRegular.copyWith(
                              fontSize: isMobile ? 11.5 : 12.5,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.75),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Interruptor Reactivo de Guardia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isAvailable
                            ? "🟢 En Guardia / Disponible en Vía"
                            : "🔴 Fuera de Turno / No Disponible",
                        style: ubuntuBold.copyWith(
                          fontSize: isMobile ? 12 : 13,
                          color: isAvailable
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: isMobile ? 0.85 : 0.95,
                child: Switch(
                  value: isAvailable,
                  activeThumbColor: const Color(0xFF10B981),
                  activeTrackColor:
                      const Color(0xFF10B981).withValues(alpha: 0.35),
                  inactiveThumbColor: const Color(0xFF94A3B8),
                  inactiveTrackColor:
                      const Color(0xFF94A3B8).withValues(alpha: 0.25),
                  onChanged: (val) {
                    auth.toggleLawyerAvailability();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. TARJETA DE ASIGNACIÓN ACTIVA (CÓDIGO ROJO / ALERTA EN CURSO) ---
  Widget _buildActiveCaseBanner(
    BuildContext context,
    LegalCase? activeCase,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Si NO tiene caso activo asignado
    if (activeCase == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF10B981),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sin siniestros activos asignados",
                    style: ubuntuBold.copyWith(
                      fontSize: isMobile ? 13.5 : 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Mantén tu estado en guardia. El despacho central te notificará al recibir una alerta SOS en tu zona.",
                    style: ubuntuRegular.copyWith(
                      fontSize: isMobile ? 11 : 12,
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Si TIENE CASO ACTIVO ASIGNADO
    final isRed = activeCase.alertaNivel == AlertaNivel.critico ||
        activeCase.tieneHeridosORetencion;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
        border: Border.all(
          color: isRed ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: (isRed ? const Color(0xFFDC2626) : const Color(0xFF2563EB))
                .withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner superior de urgencia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isRed
                    ? [const Color(0xFFDC2626), const Color(0xFF991B1B)]
                    : [const Color(0xFF2563EB), const Color(0xFF1D4ED8)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Dimensions.radiusLarge - 2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isRed
                      ? Icons.emergency_rounded
                      : Icons.directions_car_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isRed
                        ? "🚨 SINIESTRO EN CURSO — PRIORIDAD PENAL COIP"
                        : "🚗 ATENCIÓN DE ASISTENCIA EN VÍA ASIGNADA",
                    style: ubuntuBold.copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 11 : 12,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    activeCase.id,
                    style: ubuntuBold.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cuerpo de la asignación
          Padding(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo de incidente y severidad
                Text(
                  activeCase.tipoIncidente,
                  style: ubuntuBold.copyWith(
                    fontSize: isMobile ? 15 : 17,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    activeCase.articuloCoip,
                    style: ubuntuMedium.copyWith(
                      fontSize: 11,
                      color: const Color(0xFF1D4ED8),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Ficha del Conductor y Ubicación
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_rounded,
                              size: 16, color: Color(0xFF1D4ED8)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${activeCase.taxistaNombre} (${activeCase.unidad} · ${activeCase.cooperativa})",
                              style: ubuntuBold.copyWith(
                                fontSize: isMobile ? 12.5 : 13.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            activeCase.placa,
                            style: ubuntuMedium.copyWith(
                              fontSize: 11.5,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.pin_drop_rounded,
                              size: 16, color: Color(0xFFEF4444)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              activeCase.ubicacionDireccion,
                              style: ubuntuRegular.copyWith(
                                fontSize: isMobile ? 11.5 : 12.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // BOTONES DE ACCIÓN RÁPIDA
                Row(
                  children: [
                    // Botón Navegar al siniestro (Google Maps / Waze)
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D4ED8),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12 : 14,
                            horizontal: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _openNavigation(
                            activeCase.lat, activeCase.lng),
                        icon: const Icon(Icons.navigation_rounded, size: 18),
                        label: Text(
                          "Navegar",
                          style: ubuntuBold.copyWith(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Botón Llamar al conductor
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF059669),
                          side: const BorderSide(
                              color: Color(0xFF059669), width: 1.5),
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 12 : 14,
                            horizontal: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () =>
                            _callDriver(activeCase.taxistaTelefono),
                        icon: const Icon(Icons.phone_in_talk_rounded,
                            size: 18),
                        label: Text(
                          "Llamar",
                          style: ubuntuBold.copyWith(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Botón Expediente 360°
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                        foregroundColor: isDark
                            ? Colors.white
                            : const Color(0xFF1E293B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () =>
                          _showExpedienteModal(context, activeCase),
                      icon: const Icon(Icons.folder_shared_rounded,
                          size: 20),
                      tooltip: "Ver Expediente 360°",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. SECCIÓN: MIS CASOS ASIGNADOS ---
  Widget _buildMyCasesSection(
    BuildContext context,
    LegalCenterController ctrl,
    List<LegalCase> cases,
    bool isMobile,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mis Casos Asignados",
              style: ubuntuBold.copyWith(
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF1D4ED8).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${cases.length} caso(s)",
                style: ubuntuBold.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Filtros rápidos por estado
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterChip("Todos", 0),
              const SizedBox(width: 8),
              _buildFilterChip("En Camino", 1),
              const SizedBox(width: 8),
              _buildFilterChip("En Trámite", 2),
              const SizedBox(width: 8),
              _buildFilterChip("Finalizados", 3),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Listado vertical reactivo
        if (cases.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: 42,
                  color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 10),
                Text(
                  "No hay expedientes en esta categoría",
                  style: ubuntuMedium.copyWith(
                    fontSize: 13,
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final c = cases[index];
              return _buildCaseCard(context, c, isMobile);
            },
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int filterIndex) {
    final isSelected = _selectedStatusFilter == filterIndex;
    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : null,
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF1D4ED8),
      backgroundColor: Theme.of(context).cardColor,
      side: BorderSide(
        color: isSelected
            ? const Color(0xFF1D4ED8)
            : Theme.of(context).dividerColor.withValues(alpha: 0.4),
      ),
      onSelected: (val) {
        if (val) {
          HapticFeedback.lightImpact();
          setState(() {
            _selectedStatusFilter = filterIndex;
          });
        }
      },
    );
  }

  Widget _buildCaseCard(BuildContext context, LegalCase c, bool isMobile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      onTap: () => _showExpedienteModal(context, c),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
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
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            c.alertaNivel.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        c.id,
                        style: ubuntuBold.copyWith(
                          fontSize: 11,
                          color: c.alertaNivel.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        c.cooperativa,
                        style: ubuntuMedium.copyWith(
                          fontSize: 12,
                          color: theme.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.65),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: c.estadoColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    c.estadoLabel,
                    style: ubuntuBold.copyWith(
                      fontSize: 11,
                      color: c.estadoColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              c.tipoIncidente,
              style: ubuntuBold.copyWith(
                fontSize: isMobile ? 13.5 : 14.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    "${c.taxistaNombre} (${c.unidad}) · ${c.placa}",
                    style: ubuntuRegular.copyWith(
                      fontSize: 11.5,
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.75),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Color(0xFF1D4ED8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
