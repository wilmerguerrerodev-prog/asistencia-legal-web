import 'package:flutter/material.dart';
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
import '../widgets/legal_realtime_table.dart';
import '../widgets/legal_territorial_header.dart';
import '../widgets/territory_lawyers_grid.dart';

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

    return Scaffold(
      drawer: isMobile ? const MenuDrawer() : null,
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
                              // BANNER DE ENCABEZADO EJECUTIVO
                              _buildExecutiveHeader(context, isMobile),

                              const SizedBox(height: 14),

                              // BLOQUE 1: CABECERA DE FILTROS TERRITORIALES Y KPIS
                              const LegalTerritorialHeader(),

                              const SizedBox(height: 16),

                              // SELECTOR DE PESTAÑAS EJECUTIVAS (Bloque 2 vs Bloque 3)
                              _buildDashboardTabsSelector(context, ctrl),

                              const SizedBox(height: 14),

                              // CONTENIDO SEGÚN LA PESTAÑA ACTIVA
                              if (ctrl.dashboardTab == 0)
                                // BLOQUE 2: TABLA CENTRAL DE INCIDENTES EN TIEMPO REAL
                                const LegalRealtimeTable()
                              else
                                // BLOQUE 3: PANEL DE SUPERVISIÓN DE ABOGADOS DE TERRITORIO
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
}
