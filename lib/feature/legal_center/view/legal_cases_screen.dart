import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/menu/model/menu_model.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import '../widgets/cooperative_filter_chips.dart';
import '../widgets/expediente_360_panel.dart';
import '../widgets/legal_mobile_nav_header.dart';

class LegalCasesScreen extends StatefulWidget {
  const LegalCasesScreen({super.key});

  @override
  State<LegalCasesScreen> createState() => _LegalCasesScreenState();
}

class _LegalCasesScreenState extends State<LegalCasesScreen> {
  late LegalCenterController controller;
  CaseStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LegalCenterController>()) {
      controller = Get.put(LegalCenterController());
    } else {
      controller = Get.find<LegalCenterController>();
    }

    // Inicializar sin filtros residuales de otras pantallas sin disparar update() durante el build
    controller.resetCasesFilters(shouldUpdate: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MenuDrawerController>()) {
        final menuController = Get.find<MenuDrawerController>();
        for (int i = 0; i < menuList.length; i++) {
          final subMenus = menuList[i].subMenus;
          if (subMenus != null) {
            for (final sub in subMenus) {
              if (sub.route == RouteHelper.getLegalCasesRoute()) {
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
          activeIndex: 1,
          title: "Siniestros & Casos",
          subtitle: "Expedientes viales en tiempo real",
        ),
        body: GetBuilder<LegalCenterController>(
          builder: (ctrl) {
            final cases = _getFilteredCases(ctrl);
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
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _buildStatusMetrics(context, ctrl),
                    const SizedBox(height: 12),
                    const CooperativeFilterChips(),
                    const SizedBox(height: 12),
                    _buildCasesTableCard(context, cases, ctrl),
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
            if (ResponsiveHelper.isDesktop(context)) const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: GetBuilder<LegalCenterController>(
                      builder: (ctrl) {
                        final cases = _getFilteredCases(ctrl);
                        return SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeSmall,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(context),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              _buildStatusMetrics(context, ctrl),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              const CooperativeFilterChips(),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              _buildCasesTableCard(context, cases, ctrl),
                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
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

  List<LegalCase> _getFilteredCases(LegalCenterController ctrl) {
    return ctrl.allCases.where((c) {
      if (_statusFilter != null && c.estado != _statusFilter) {
        return false;
      }
      if (ctrl.selectedCooperative != 'Todas' &&
          !c.cooperativa.toLowerCase().contains(
                ctrl.selectedCooperative.toLowerCase().replaceAll('coop. ', ''),
              )) {
        return false;
      }
      final query = ctrl.searchQuery.toLowerCase().trim();
      if (query.isNotEmpty) {
        final matches = c.id.toLowerCase().contains(query) ||
            c.taxistaNombre.toLowerCase().contains(query) ||
            c.taxistaCedula.toLowerCase().contains(query) ||
            c.placa.toLowerCase().contains(query) ||
            c.unidad.toLowerCase().contains(query) ||
            c.cooperativa.toLowerCase().contains(query) ||
            c.tipoIncidente.toLowerCase().contains(query) ||
            c.ubicacionDireccion.toLowerCase().contains(query) ||
            c.canton.toLowerCase().contains(query);
        if (!matches) return false;
      }
      return true;
    }).toList();
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.folder_shared_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gestión de Casos y Siniestros Viales",
                  style: ubuntuBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: 4),
                Text(
                  "Historial completo de reportes, tipificación COIP y trazabilidad en vía pública.",
                  style: ubuntuRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMetrics(BuildContext context, LegalCenterController ctrl) {
    final all = ctrl.allCases;
    final pendientes = all.where((c) => c.estado == CaseStatus.pendiente).length;
    final dictamenes = all.where((c) => c.estado == CaseStatus.dictamenAprobado).length;
    final despachados = all.where((c) => c.estado == CaseStatus.abogadoDespachado).length;
    final atendidos = all.where((c) => c.estado == CaseStatus.atendido).length;

    final chips = [
      _metricChip(context, "Todos los Casos", "${all.length}", Colors.blue, null),
      _metricChip(context, "Pendientes", "$pendientes", Colors.red, CaseStatus.pendiente),
      _metricChip(context, "Dictamen Listo", "$dictamenes", Colors.green, CaseStatus.dictamenAprobado),
      _metricChip(context, "En Camino", "$despachados", Colors.orange, CaseStatus.abogadoDespachado),
      _metricChip(context, "Resueltos", "$atendidos", Colors.teal, CaseStatus.atendido),
    ];

    final isMobile = ResponsiveHelper.isMobile(context);
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips.map((chip) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(width: 120, child: chip),
          )).toList(),
        ),
      );
    }

    return Row(
      children: chips.map((chip) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: chip,
      ))).toList(),
    );
  }

  Widget _metricChip(BuildContext context, String label, String value, Color color, CaseStatus? status) {
    final isSelected = _statusFilter == status;
    return InkWell(
      onTap: () => setState(() => _statusFilter = status),
      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerColor.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(value, style: ubuntuBold.copyWith(fontSize: 20, color: color)),
            const SizedBox(height: 2),
            Text(
              label,
              style: ubuntuMedium.copyWith(
                fontSize: 11,
                color: isSelected ? color : Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCasesTableCard(BuildContext context, List<LegalCase> cases, LegalCenterController ctrl) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Listado de Expedientes (${cases.length})",
                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Toque un caso para ver el Expediente 360°",
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Listado de Expedientes (${cases.length})",
                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                      ),
                      Text(
                        "Haga clic en un caso para ver el Expediente 360°",
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
          ),
          const Divider(height: 1),
          if (cases.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 10),
                    const Text("No se encontraron casos con el filtro seleccionado.", style: ubuntuMedium),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cases.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = cases[index];
                return isMobile
                    ? _buildMobileCaseCard(context, c, ctrl)
                    : _buildCaseRow(context, c, ctrl);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMobileCaseCard(BuildContext context, LegalCase c, LegalCenterController ctrl) {
    Color statusColor;
    String statusText;
    switch (c.estado) {
      case CaseStatus.pendiente:
        statusColor = const Color(0xFFD32F2F);
        statusText = "Pendiente";
        break;
      case CaseStatus.dictamenAprobado:
        statusColor = const Color(0xFF2E7D32);
        statusText = "Dictamen Listo";
        break;
      case CaseStatus.abogadoDespachado:
        statusColor = const Color(0xFF1565C0);
        statusText = "Abogado en Vía";
        break;
      case CaseStatus.atendido:
        statusColor = const Color(0xFF455A64);
        statusText = "Resuelto";
        break;
    }

    return InkWell(
      onTap: () {
        ctrl.selectCase(c);
        _showExpedienteModal(context, c);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF056AB4).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(c.id, style: ubuntuBold.copyWith(color: const Color(0xFF056AB4), fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(c.cooperativa, style: ubuntuMedium.copyWith(fontSize: 11)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(statusText, style: ubuntuBold.copyWith(fontSize: 10, color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(c.taxistaNombre, style: ubuntuBold.copyWith(fontSize: 14)),
            const SizedBox(height: 2),
            Text(
              "${c.unidad} • Placa: ${c.placa} • ${c.vehiculoModelo}",
              style: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.car_crash_outlined, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Expanded(child: Text(c.tipoIncidente, style: ubuntuMedium.copyWith(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c.ubicacionDireccion,
                    style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.folder_open_rounded, size: 14),
                label: const Text("Ver Expediente 360°"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  textStyle: ubuntuMedium.copyWith(fontSize: 11),
                ),
                onPressed: () {
                  ctrl.selectCase(c);
                  _showExpedienteModal(context, c);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseRow(BuildContext context, LegalCase c, LegalCenterController ctrl) {
    Color statusColor;
    String statusText;
    switch (c.estado) {
      case CaseStatus.pendiente:
        statusColor = const Color(0xFFD32F2F);
        statusText = "Pendiente";
        break;
      case CaseStatus.dictamenAprobado:
        statusColor = const Color(0xFF2E7D32);
        statusText = "Dictamen Listo";
        break;
      case CaseStatus.abogadoDespachado:
        statusColor = const Color(0xFF1565C0);
        statusText = "Abogado en Vía";
        break;
      case CaseStatus.atendido:
        statusColor = const Color(0xFF455A64);
        statusText = "Resuelto";
        break;
    }

    return InkWell(
      onTap: () {
        ctrl.selectCase(c);
        _showExpedienteModal(context, c);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF056AB4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(c.id, style: ubuntuBold.copyWith(color: const Color(0xFF056AB4), fontSize: 12)),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.taxistaNombre, style: ubuntuBold.copyWith(fontSize: 13)),
                  Text(
                    "${c.unidad} • Placa ${c.placa} • ${c.cooperativa}",
                    style: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.tipoIncidente, style: ubuntuMedium.copyWith(fontSize: 12)),
                  Text(
                    c.ubicacionDireccion,
                    style: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              child: Text(statusText, style: ubuntuBold.copyWith(fontSize: 11, color: statusColor)),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              tooltip: "Abrir Expediente 360°",
              onPressed: () {
                ctrl.selectCase(c);
                _showExpedienteModal(context, c);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExpedienteModal(BuildContext context, LegalCase c) {
    final isMobile = ResponsiveHelper.isMobile(context);

    // En móviles: Modal Bottom Sheet arrastrable fluido
    if (isMobile) {
      HapticFeedback.mediumImpact();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (sheetContext, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Indicador de arrastre táctil (drag handle)
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

                // Encabezado móvil del expediente
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D47A1).withValues(alpha: 0.12),
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

                // Contenido del Expediente con scroll táctil
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

    // Modo Escritorio / Web (Dialog centrado)
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 750,
          height: 650,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.folder_shared_rounded, color: Color(0xFF056AB4), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Expediente Digital 360° • ${c.id}",
                              style: ubuntuBold.copyWith(fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Expediente360Panel(caseItem: c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
