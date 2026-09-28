import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/menu/model/menu_model.dart';
import '../controller/legal_center_controller.dart';
import '../widgets/legal_mobile_nav_header.dart';
import '../widgets/legal_realtime_table.dart';
import '../widgets/legal_territorial_header.dart';
import '../widgets/territory_lawyers_grid.dart';
import '../widgets/legal_dispatch_map.dart';

class LegalCenterScreen extends StatefulWidget {
  const LegalCenterScreen({super.key});

  @override
  State<LegalCenterScreen> createState() => _LegalCenterScreenState();
}

class _LegalCenterScreenState extends State<LegalCenterScreen> {
  late LegalCenterController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LegalCenterController>()) {
      controller = Get.put(LegalCenterController());
    } else {
      controller = Get.find<LegalCenterController>();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MenuDrawerController>()) {
        final menuController = Get.find<MenuDrawerController>();
        for (int i = 0; i < menuList.length; i++) {
          final subMenus = menuList[i].subMenus;
          if (subMenus != null) {
            for (final sub in subMenus) {
              if (sub.route == RouteHelper.getEdutechRoute()) {
                menuController.updateSelectedIndex(i);
                menuController.updateSubMenuSelectedIndex(sub.subMenuTitle ?? '');
                break;
              }
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // ==========================================
    // MODO MÓVIL (PRIORIDAD PRINCIPAL INTERFAZ)
    // ==========================================
    if (isMobile) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const LegalMobileNavHeader(
          activeIndex: 0,
          title: "Monitor Legal",
          subtitle: "Mando territorial y despacho en vía",
        ),
        body: GetBuilder<LegalCenterController>(
          builder: (ctrl) {
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
                    // BANNER DE ENCABEZADO EJECUTIVO
                    _buildExecutiveHeader(context, true),

                    const SizedBox(height: 12),

                    // BLOQUE 1: CABECERA DE FILTROS TERRITORIALES Y KPIS
                    const LegalTerritorialHeader(),

                    const SizedBox(height: 14),

                    // SELECTOR DE PESTAÑAS (Incidentes vs Abogados)
                    _buildDashboardTabsSelector(context, ctrl),

                    const SizedBox(height: 12),

                    // CONTENIDO SEGÚN LA PESTAÑA ACTIVA
                    if (ctrl.dashboardTab == 0) ...[
                      _buildViewModeSelector(context, ctrl),
                      const SizedBox(height: 12),
                      _buildRealtimeIncidentsContent(context, ctrl),
                    ] else
                      const TerritoryLawyersGrid(),

                    const SizedBox(height: 36),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    // ==========================================
    // MODO ESCRITORIO / WEB (FALLBACK RESPONSIVO)
    // ==========================================
    return Scaffold(
      drawer: null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menú lateral en escritorio
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),

            // Área central ejecutiva
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: GetBuilder<LegalCenterController>(
                      builder: (ctrl) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildExecutiveHeader(context, false),
                              const SizedBox(height: 14),
                              const LegalTerritorialHeader(),
                              const SizedBox(height: 16),
                              _buildDashboardTabsSelector(context, ctrl),
                              const SizedBox(height: 14),
                              if (ctrl.dashboardTab == 0) ...[
                                _buildViewModeSelector(context, ctrl),
                                const SizedBox(height: 12),
                                _buildRealtimeIncidentsContent(context, ctrl),
                              ] else
                                const TerritoryLawyersGrid(),
                              const SizedBox(height: 24),
                              const FooterSection(),
                            ],
                          ),
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

  // --- BANNER DE ENCABEZADO EJECUTIVO MINIMALISTA ---
  Widget _buildExecutiveHeader(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.gavel_rounded,
              color: Colors.white,
              size: isMobile ? 18 : 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Panel de Control LegalTech • Despacho Inmediato',
                  style: ubuntuBold.copyWith(
                    fontSize: isMobile ? Dimensions.fontSizeDefault : Dimensions.fontSizeLarge,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Gestión ejecutiva de siniestros viales y supervisión de abogados en territorio ecuatoriano.',
                  style: ubuntuRegular.copyWith(
                    fontSize: isMobile ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeSmall,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  maxLines: isMobile ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isMobile && MediaQuery.of(context).size.width >= 850) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Despacho Activo 24/7',
                    style: ubuntuBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- SELECTOR DE PESTAÑAS EJECUTIVAS ---
  Widget _buildDashboardTabsSelector(
    BuildContext context,
    LegalCenterController ctrl,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // PESTAÑA 1: INCIDENTES EN TIEMPO REAL
          Expanded(
            child: _tabButton(
              context: context,
              title: isMobile ? 'Incidentes' : 'Incidentes en Tiempo Real',
              countBadge: '${ctrl.filteredCases.length}',
              icon: Icons.table_chart_rounded,
              isSelected: ctrl.dashboardTab == 0,
              isMobile: isMobile,
              onTap: () => ctrl.setDashboardTab(0),
            ),
          ),
          const SizedBox(width: 6),

          // PESTAÑA 2: SUPERVISIÓN DE ABOGADOS DE TERRITORIO
          Expanded(
            child: _tabButton(
              context: context,
              title: isMobile ? 'Supervisión' : 'Supervisión de Abogados de Territorio',
              countBadge: '${ctrl.territoryLawyers.length}',
              icon: Icons.supervised_user_circle_rounded,
              isSelected: ctrl.dashboardTab == 1,
              isMobile: isMobile,
              onTap: () => ctrl.setDashboardTab(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required BuildContext context,
    required String title,
    required String countBadge,
    required IconData icon,
    required bool isSelected,
    required bool isMobile,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 8 : 10,
          horizontal: isMobile ? 4 : 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : Theme.of(context).hintColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: ubuntuBold.copyWith(
                  fontSize: isMobile ? 11 : Dimensions.fontSizeSmall,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge!.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                countBadge,
                style: ubuntuBold.copyWith(
                  fontSize: 10,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SELECTOR DE MODO DE VISTA ADAPTATIVO: DIVIDIDA (TABLA + MAPA) | SOLO TABLA | SOLO MAPA ---
  Widget _buildViewModeSelector(
    BuildContext context,
    LegalCenterController ctrl,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 520;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 6 : 12,
            vertical: isCompact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: isCompact
              ? Row(
                  children: [
                    Expanded(
                      child: _viewModeButton(
                        context: context,
                        title: 'Dividida',
                        icon: Icons.splitscreen_rounded,
                        isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.split,
                        isCompact: true,
                        onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.split),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _viewModeButton(
                        context: context,
                        title: 'Tabla',
                        icon: Icons.table_chart_rounded,
                        isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.tableOnly,
                        isCompact: true,
                        onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.tableOnly),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _viewModeButton(
                        context: context,
                        title: 'Mapa',
                        icon: Icons.map_rounded,
                        isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.mapOnly,
                        isCompact: true,
                        onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.mapOnly),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.dashboard_customize_rounded,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Centro de Mando:',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _viewModeButton(
                          context: context,
                          title: 'Dividida (Tabla + Mapa)',
                          icon: Icons.splitscreen_rounded,
                          isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.split,
                          onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.split),
                        ),
                        const SizedBox(width: 6),
                        _viewModeButton(
                          context: context,
                          title: 'Solo Tabla',
                          icon: Icons.table_chart_rounded,
                          isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.tableOnly,
                          onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.tableOnly),
                        ),
                        const SizedBox(width: 6),
                        _viewModeButton(
                          context: context,
                          title: 'Solo Mapa',
                          icon: Icons.map_rounded,
                          isSelected: ctrl.dispatchViewMode == LegalDispatchViewMode.mapOnly,
                          onTap: () => ctrl.setDispatchViewMode(LegalDispatchViewMode.mapOnly),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _viewModeButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 4 : 10,
          vertical: isCompact ? 7 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).dividerColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isCompact ? 12 : 13,
              color: isSelected ? Colors.white : Theme.of(context).hintColor,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                title,
                style: ubuntuBold.copyWith(
                  fontSize: isCompact ? 10 : 11,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
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

  // --- RENDERIZADO EQUILIBRADO RESPONSIVO DE TABLA Y MAPA INTERACTIVO ---
  Widget _buildRealtimeIncidentsContent(
    BuildContext context,
    LegalCenterController ctrl,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeDesktop = screenWidth >= 1200;

    // Altura del mapa dinámicamente adaptada al dispositivo (teléfonos, tablets y desktops)
    final double adaptiveMapHeight;
    if (isLargeDesktop) {
      adaptiveMapHeight = 720;
    } else if (screenWidth >= 768) {
      adaptiveMapHeight = 480;
    } else {
      // En teléfonos (pantallas de 320px a 450px)
      adaptiveMapHeight = (screenHeight * 0.42).clamp(290.0, 390.0);
    }

    final double fullScreenMapHeight;
    if (screenWidth < 600) {
      fullScreenMapHeight = (screenHeight * 0.74).clamp(420.0, 680.0);
    } else {
      fullScreenMapHeight = 760;
    }

    switch (ctrl.dispatchViewMode) {
      case LegalDispatchViewMode.split:
        if (isLargeDesktop) {
          // Distribución en paralelo split-view de alta fidelidad para escritorio
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tabla reactiva de incidentes en tiempo real
              const Expanded(
                flex: 6,
                child: LegalRealtimeTable(isSplitView: true),
              ),
              const SizedBox(width: 14),

              // 2. Mapa interactivo de despacho y triage en vivo
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: adaptiveMapHeight,
                  child: LegalDispatchMap(
                    onToggleFullScreen: () {
                      ctrl.setDispatchViewMode(LegalDispatchViewMode.mapOnly);
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          // Pantallas de smartphone, tablet o laptop compacta: apiladas armónicamente
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LegalRealtimeTable(isSplitView: true),
              const SizedBox(height: 14),
              SizedBox(
                height: adaptiveMapHeight,
                child: LegalDispatchMap(
                  onToggleFullScreen: () {
                    ctrl.setDispatchViewMode(LegalDispatchViewMode.mapOnly);
                  },
                ),
              ),
            ],
          );
        }

      case LegalDispatchViewMode.tableOnly:
        return const LegalRealtimeTable(isSplitView: false);

      case LegalDispatchViewMode.mapOnly:
        return SizedBox(
          height: fullScreenMapHeight,
          child: LegalDispatchMap(
            isFullScreen: true,
            onToggleFullScreen: () {
              ctrl.setDispatchViewMode(LegalDispatchViewMode.split);
            },
          ),
        );
    }
  }
}
