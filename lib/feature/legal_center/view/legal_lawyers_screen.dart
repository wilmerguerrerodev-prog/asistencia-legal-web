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
import '../widgets/assign_lawyer_case_dialog.dart';
import '../widgets/legal_mobile_nav_header.dart';

class LegalLawyersScreen extends StatefulWidget {
  const LegalLawyersScreen({super.key});

  @override
  State<LegalLawyersScreen> createState() => _LegalLawyersScreenState();
}

class _LegalLawyersScreenState extends State<LegalLawyersScreen> {
  late final LegalCenterController _legalController;
  late List<Map<String, dynamic>> _lawyersData;

  @override
  void initState() {
    super.initState();
    _legalController = Get.isRegistered<LegalCenterController>()
        ? Get.find<LegalCenterController>()
        : Get.put(LegalCenterController());

    _lawyersData = [
      {
        "nombre": "Dra. Elena Torres",
        "unidad": "Móvil Legal #02 • Zona Norte",
        "estado": "Disponible en Patrullaje",
        "color": const Color(0xFF2E7D32),
        "ubicacion": "Redondel del Labrador • Av. Amazonas y Galo Plaza",
        "vehiculo": "Suzuki Grand Vitara (PBX-3012)",
        "telefono": "+593 99 445 1200",
        "casosHoy": "2 casos resueltos con éxito",
        "especialidad": "Conciliación en vía pública y peritajes SIAT",
      },
      {
        "nombre": "Dr. Marcelo Dávila",
        "unidad": "Móvil Legal #01 • Zona Sur",
        "estado": "En Camino a Siniestro #CASO-1028",
        "color": const Color(0xFFE65100),
        "ubicacion": "Av. Rodrigo de Chávez y 5 de Junio (Villaflora) • ETA: 6 min",
        "vehiculo": "Renault Duster (PBA-9921)",
        "telefono": "+593 98 776 5544",
        "casosHoy": "1 caso en atención activa",
        "especialidad": "Evitar retención vehicular Art. 380 COIP",
      },
      {
        "nombre": "Dr. Fernando Salazar",
        "unidad": "Móvil Legal #03 • Centro & Tribunales",
        "estado": "En Audiencia de Tránsito",
        "color": const Color(0xFF1565C0),
        "ubicacion": "Juzgado de Tránsito La Pradera • Sala 4",
        "vehiculo": "Chevrolet Tracker (PCY-1100)",
        "telefono": "+593 99 112 3344",
        "casosHoy": "1 impugnación de citación en trámite",
        "especialidad": "Impugnación de contravenciones y fotomultas",
      },
      {
        "nombre": "Abg. Patricia Vinueza",
        "unidad": "Móvil Legal #04 • Valles",
        "estado": "Disponible en Guardia",
        "color": const Color(0xFF2E7D32),
        "ubicacion": "Interoceánica y Av. Oswaldo Guayasamín (Cumbayá)",
        "vehiculo": "Kia Sportage (PCZ-4412)",
        "telefono": "+593 96 889 0011",
        "casosHoy": "1 caso cerrado hoy",
        "especialidad": "Acuerdos extrajudiciales y cobertura de aseguradoras",
      },
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MenuDrawerController>()) {
        final menuController = Get.find<MenuDrawerController>();
        for (int i = 0; i < menuList.length; i++) {
          final subMenus = menuList[i].subMenus;
          if (subMenus != null) {
            for (final sub in subMenus) {
              if (sub.route == RouteHelper.getLegalLawyersRoute()) {
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

  void _handleConfirmAssignment(
    int index,
    Map<String, dynamic> law,
    String caseId,
    bool isQueued,
    String etaMinutes,
    String caseTitle,
  ) {
    final lawyerName = law["nombre"] as String;
    setState(() {
      if (isQueued) {
        _lawyersData[index]["casosHoy"] = "${law["casosHoy"]} • En cola: $caseId";
      } else {
        _lawyersData[index]["estado"] = "En Camino a Siniestro $caseId";
        _lawyersData[index]["color"] = const Color(0xFFE65100);
        _lawyersData[index]["casosHoy"] = "1 caso en atención activa ($caseId)";
        final baseLoc = (law["ubicacion"] as String).split('•').first.trim();
        _lawyersData[index]["ubicacion"] = "$baseLoc • ETA: $etaMinutes min";
      }
    });

    if (isQueued) {
      _legalController.enqueueCaseForLawyer(caseId, lawyerName, incidentTitle: caseTitle);
    } else {
      _legalController.dispatchLawyer(caseId, lawyerName, etaMinutes);
    }
  }

  void _openAssignCaseDialog(BuildContext context, int index) {
    final law = _lawyersData[index];
    final isMobile = ResponsiveHelper.isMobile(context);

    // En móviles: Modal Bottom Sheet arrastrable y táctil
    if (isMobile) {
      HapticFeedback.mediumImpact();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (bottomSheetCtx) => DraggableScrollableSheet(
          initialChildSize: 0.88,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (ctx, scrollCtrl) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    child: AssignLawyerCaseDialog(
                      lawyer: law,
                      onConfirmAssignment: ({
                        required String caseId,
                        required bool isQueued,
                        required String etaMinutes,
                        required String mode,
                        required String caseTitle,
                      }) {
                        _handleConfirmAssignment(index, law, caseId, isQueued, etaMinutes, caseTitle);
                      },
                    ),
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
      barrierDismissible: true,
      builder: (dialogCtx) => AssignLawyerCaseDialog(
        lawyer: law,
        onConfirmAssignment: ({
          required String caseId,
          required bool isQueued,
          required String etaMinutes,
          required String mode,
          required String caseTitle,
        }) {
          _handleConfirmAssignment(index, law, caseId, isQueued, etaMinutes, caseTitle);
        },
      ),
    );
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
          activeIndex: 2,
          title: "Abogados en Vía",
          subtitle: "Patrullaje legal y asignación",
        ),
        body: RefreshIndicator(
          color: const Color(0xFF1D4ED8),
          onRefresh: () async {
            HapticFeedback.lightImpact();
            setState(() {});
            _legalController.update();
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
                _buildKPIs(context),
                const SizedBox(height: 12),
                _buildLawyersList(context),
                const SizedBox(height: 12),
                _buildSLAInfoCard(context),
                const SizedBox(height: 36),
              ],
            ),
          ),
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          _buildKPIs(context),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          _buildLawyersList(context),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          _buildSLAInfoCard(context),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          const FooterSection(),
                        ],
                      ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.2),
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
            child: const Icon(Icons.car_crash_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Abogados en Territorio • Unidades Móviles en Vía",
                  style: ubuntuBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
                ),
                const SizedBox(height: 4),
                Text(
                  "Monitoreo de patrullaje legal en tiempo real, SLA de arribo a siniestros y despacho inmediato.",
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

  Widget _buildKPIs(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final totalLawyers = _lawyersData.length;
    final enCamino = _lawyersData.where((l) => l["estado"].toString().contains("En Camino")).length;
    final disponibles = _lawyersData.where((l) => l["estado"].toString().contains("Disponible")).length;

    final kpis = [
      _kpiCard(context, "Abogados en Guardia", "$totalLawyers", "Unidades activas 24/7", const Color(0xFF0D47A1), Icons.badge_rounded),
      _kpiCard(context, "En Camino a Siniestro", "$enCamino", enCamino > 0 ? "Atención activa en vía" : "Sin despachos activos", const Color(0xFFE65100), Icons.directions_car_rounded),
      _kpiCard(context, "Disponibles en Vía", "$disponibles", "Listos para asignación", const Color(0xFF2E7D32), Icons.check_circle_rounded),
      _kpiCard(context, "Tiempo Prom. Arribo (SLA)", "12.4 min", "Meta legal: <15 min", const Color(0xFF6A1B9A), Icons.timer_rounded),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: kpis.map((k) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(width: 210, child: k),
          )).toList(),
        ),
      );
    }

    return Row(
      children: kpis.map((k) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: k,
      ))).toList(),
    );
  }

  Widget _kpiCard(BuildContext context, String title, String value, String sub, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6))),
                const SizedBox(height: 2),
                Text(value, style: ubuntuBold.copyWith(fontSize: 18, color: color)),
                Text(sub, style: ubuntuRegular.copyWith(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLawyersList(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
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
                      Text("Cuerpo de Abogados de Turno (${_lawyersData.length})", style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: 6),
                      _buildGpsBadge(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cuerpo de Abogados de Turno (${_lawyersData.length})", style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      _buildGpsBadge(),
                    ],
                  ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _lawyersData.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final law = _lawyersData[index];
              final color = law["color"] as Color;
              return isMobile
                  ? _buildMobileLawyerCard(context, index, law, color)
                  : _buildDesktopLawyerRow(context, index, law, color);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGpsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2E7D32))),
          const SizedBox(width: 6),
          Text("Enlace GPS Activo", style: ubuntuBold.copyWith(color: const Color(0xFF2E7D32), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildMobileLawyerCard(BuildContext context, int index, Map<String, dynamic> law, Color color) {
    final bool hasQueue = law["casosHoy"].toString().contains("En cola");

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Text(
                  (law["nombre"] as String).split(' ').last.substring(0, 1),
                  style: ubuntuBold.copyWith(color: color, fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(law["nombre"] as String, style: ubuntuBold.copyWith(fontSize: 14)),
                    Text(law["unidad"] as String, style: ubuntuMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(law["estado"] as String, style: ubuntuBold.copyWith(color: color, fontSize: 9)),
                  ),
                  if (hasQueue) ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text("+1 en cola", style: ubuntuBold.copyWith(color: const Color(0xFF0D47A1), fontSize: 8)),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(law["ubicacion"] as String, style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade700))),
            ],
          ),
          const SizedBox(height: 3),
          Text("Vehículo: ${law["vehiculo"]}", style: ubuntuRegular.copyWith(fontSize: 11)),
          Text("Especialidad: ${law["especialidad"]}", style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600)),
          Text("Actividad: ${law["casosHoy"]}", style: ubuntuMedium.copyWith(fontSize: 11, color: const Color(0xFF2E7D32))),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.call_rounded, size: 13),
                  label: const Text("Llamar"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: ubuntuMedium.copyWith(fontSize: 11),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "Llamando a ${law["nombre"]}",
                      "Conectando por central telefónica LegalTech...",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send_rounded, size: 13),
                  label: const Text("Asignar Caso"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: ubuntuMedium.copyWith(fontSize: 11),
                  ),
                  onPressed: () => _openAssignCaseDialog(context, index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLawyerRow(BuildContext context, int index, Map<String, dynamic> law, Color color) {
    final bool hasQueue = law["casosHoy"].toString().contains("En cola");

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Text(
              (law["nombre"] as String).split(' ').last.substring(0, 1),
              style: ubuntuBold.copyWith(color: color, fontSize: 16),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(law["nombre"] as String, style: ubuntuBold.copyWith(fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(law["estado"] as String, style: ubuntuBold.copyWith(color: color, fontSize: 10)),
                    ),
                    if (hasQueue) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("+1 en cola", style: ubuntuBold.copyWith(color: const Color(0xFF0D47A1), fontSize: 9)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(law["unidad"] as String, style: ubuntuMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: 12)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(law["ubicacion"] as String, style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade700))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vehículo: ${law["vehiculo"]}", style: ubuntuRegular.copyWith(fontSize: 11)),
                Text("Especialidad: ${law["especialidad"]}", style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600)),
                Text("Actividad: ${law["casosHoy"]}", style: ubuntuMedium.copyWith(fontSize: 11, color: const Color(0xFF2E7D32))),
              ],
            ),
          ),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text("Llamar"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: ubuntuMedium.copyWith(fontSize: 11),
                ),
                onPressed: () {
                  Get.snackbar(
                    "Llamando a ${law["nombre"]}",
                    "Conectando por central telefónica LegalTech...",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.send_rounded, size: 14),
                label: const Text("Asignar Caso"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: ubuntuMedium.copyWith(fontSize: 11),
                ),
                onPressed: () => _openAssignCaseDialog(context, index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSLAInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: const Color(0xFF056AB4).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: const Color(0xFF056AB4).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFF056AB4), size: 30),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Garantía de Cobertura Legal Inmediata para Cooperativas",
                  style: ubuntuBold.copyWith(color: const Color(0xFF056AB4), fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: 2),
                Text(
                  "Todas las unidades móviles cuentan con terminal digital de actas transaccionales, alcoholímetro homologado para contrapruebas y enlace directo con peritos de tránsito.",
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
