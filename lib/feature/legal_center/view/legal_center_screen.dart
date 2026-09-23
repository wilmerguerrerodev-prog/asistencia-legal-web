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
import '../widgets/cooperative_filter_chips.dart';
import '../widgets/expediente_360_panel.dart';
import '../widgets/legal_cases_table.dart';
import '../widgets/legal_kpi_header.dart';

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
            // Menú lateral izquierdo en escritorio
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),

            // Área de contenido principal
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: GetBuilder<LegalCenterController>(
                      builder: (controller) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // BANNER DE TÍTULO LEGALTECH
                              _buildTitleBanner(context, isMobile),

                              const SizedBox(height: 16),

                              // ENTORNO MÓVIL vs ESCRITORIO
                              if (isMobile)
                                _buildMobileLayout(context, controller)
                              else
                                _buildDesktopLayout(context, controller),

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

  // --- BANNER DE TÍTULO ---
  Widget _buildTitleBanner(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            const Color(0xFF0D47A1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.gavel, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Centro de Mando LegalTech • Asistencia Jurídica',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Despacho y monitoreo de siniestros viales en tiempo real para flotas y cooperativas de taxis.',
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Row(
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
                    'Enlace en Vivo Taxista ⇄ Abogado',
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

  // --- LAYOUT ESCRITORIO (VISTA DIVIDIDA 360°) ---
  Widget _buildDesktopLayout(BuildContext context, LegalCenterController controller) {
    return Column(
      children: [
        // KPIs SUPERIORES
        const LegalKpiHeader(),

        const SizedBox(height: 16),

        // FILTRO POR COOPERATIVA
        const CooperativeFilterChips(),

        const SizedBox(height: 16),

        // SPLIT SCREEN: TABLA A LA IZQUIERDA + EXPEDIENTE 360 A LA DERECHA
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LADO IZQUIERDO: TABLA DE CASOS (Flex: 6)
            const Expanded(
              flex: 6,
              child: LegalCasesTable(),
            ),

            const SizedBox(width: 16),

            // LADO DERECHO: EXPEDIENTE 360° (Flex: 5)
            Expanded(
              flex: 5,
              child: controller.selectedCase != null
                  ? Expediente360Panel(caseItem: controller.selectedCase!)
                  : Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: const Center(
                        child: Text('Seleccione un caso para ver el Expediente 360°'),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  // --- LAYOUT MÓVIL RESPONSIVO CON TABS INTUITIVAS ---
  Widget _buildMobileLayout(BuildContext context, LegalCenterController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPIs adaptados en cuadrícula
        const LegalKpiHeader(),

        const SizedBox(height: 12),

        // BARRA SELECTORA DE PESTAÑAS MÓVIL
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.setMobileTab(0),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.mobileTabIndex == 0
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt_rounded,
                          size: 16,
                          color: controller.mobileTabIndex == 0 ? Colors.white : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Casos (${controller.filteredCases.length})',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: controller.mobileTabIndex == 0 ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => controller.setMobileTab(1),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.mobileTabIndex == 1
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_shared_rounded,
                          size: 16,
                          color: controller.mobileTabIndex == 1 ? Colors.white : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Expediente 360°',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: controller.mobileTabIndex == 1 ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // CONTENIDO SEGÚN LA PESTAÑA SELECCIONADA EN MÓVIL
        if (controller.mobileTabIndex == 0) ...[
          const CooperativeFilterChips(),
          const SizedBox(height: 12),
          const LegalCasesTable(),
        ] else ...[
          if (controller.selectedCase != null) ...[
            // Botón de retorno rápido a la lista
            TextButton.icon(
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('← Volver a lista de casos'),
              onPressed: () => controller.setMobileTab(0),
            ),
            const SizedBox(height: 6),
            Expediente360Panel(caseItem: controller.selectedCase!),
          ] else
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: const Center(
                child: Text('No hay caso seleccionado.'),
              ),
            ),
        ],
      ],
    );
  }
}
