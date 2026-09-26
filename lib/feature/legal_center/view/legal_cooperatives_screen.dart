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
import '../widgets/legal_mobile_nav_header.dart';

class LegalCooperativesScreen extends StatefulWidget {
  const LegalCooperativesScreen({super.key});

  @override
  State<LegalCooperativesScreen> createState() => _LegalCooperativesScreenState();
}

class _LegalCooperativesScreenState extends State<LegalCooperativesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<MenuDrawerController>()) {
        final menuController = Get.find<MenuDrawerController>();
        for (int i = 0; i < menuList.length; i++) {
          final subMenus = menuList[i].subMenus;
          if (subMenus != null) {
            for (final sub in subMenus) {
              if (sub.route == RouteHelper.getLegalCooperativesRoute()) {
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
          activeIndex: 3,
          title: "Cooperativas & Flotas",
          subtitle: "Gestión de unidades y convenios",
        ),
        body: RefreshIndicator(
          color: const Color(0xFF1D4ED8),
          onRefresh: () async {
            HapticFeedback.lightImpact();
            setState(() {});
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
                _buildCooperativesGrid(context),
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
                          _buildCooperativesGrid(context),
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFF57C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE65100).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.local_taxi_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        "Cooperativas y Flotas Afiliadas",
                        style: ubuntuBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Padrón institucional, control de unidades vehiculares, estado de pólizas colectivas y convenios jurídicos.",
                  style: ubuntuRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: Dimensions.fontSizeExtraSmall,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Nueva Cooperativa"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE65100),
                    elevation: 0,
                    textStyle: ubuntuBold.copyWith(fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "Afiliación Institucional",
                      "Formulario de registro de nueva cooperativa y convenio legal.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                    );
                  },
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_taxi_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cooperativas y Flotas de Taxis Afiliadas",
                        style: ubuntuBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Padrón institucional, control de unidades vehiculares, estado de pólizas colectivas y convenios jurídicos.",
                        style: ubuntuRegular.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Nueva Cooperativa"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE65100),
                    elevation: 0,
                    textStyle: ubuntuBold.copyWith(fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "Afiliación Institucional",
                      "Formulario de registro de nueva cooperativa y convenio legal.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildKPIs(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final items = [
      _kpiCard(context, "Cooperativas Activas", "4", "Convenio LegalTech vigente", const Color(0xFFE65100), Icons.domain_rounded),
      _kpiCard(context, "Flota Total Protegida", "199 taxis", "Taxis con botón SOS activo", const Color(0xFF0D47A1), Icons.directions_car_rounded),
      _kpiCard(context, "Conductores Censados", "222 taxistas", "Cédulas y licencias validadas", const Color(0xFF2E7D32), Icons.badge_rounded),
      _kpiCard(context, "Pólizas Colectivas", "100% al día", "SOAT/SPPAT y seguro vehicular", const Color(0xFF6A1B9A), Icons.verified_user_rounded),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: items.map((card) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(width: 220, child: card),
          )).toList(),
        ),
      );
    }

    return Row(
      children: items.map((card) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: card,
        ),
      )).toList(),
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
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(value, style: ubuntuBold.copyWith(fontSize: 16, color: color)),
                Text(sub, style: ubuntuRegular.copyWith(fontSize: 10, color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.5)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCooperativesGrid(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final coops = [
      {
        "nombre": "Coop. Los Lagos",
        "tipo": "Taxis Ejecutivos y Convencionales",
        "unidades": "42 unidades activas",
        "choferes": "48 taxistas censados",
        "seguro": "Póliza Colectiva • Seguros Equinoccial",
        "siniestrosHoy": "2 casos reportados hoy",
        "contacto": "Sr. Germán Castro (Presidente)",
        "telefono": "+593 99 221 4455",
        "color": const Color(0xFF0D47A1),
      },
      {
        "nombre": "Coop. El Tejar",
        "tipo": "Taxis Convencionales Centro Histórico",
        "unidades": "68 unidades activas",
        "choferes": "75 taxistas censados",
        "seguro": "Póliza Colectiva • Aseguradora del Sur",
        "siniestrosHoy": "2 casos reportados hoy",
        "contacto": "Ing. Rocío Beltrán (Gerente)",
        "telefono": "+593 98 123 9900",
        "color": const Color(0xFF1B5E20),
      },
      {
        "nombre": "Coop. San Cristóbal",
        "tipo": "Taxis Convencionales Norte",
        "unidades": "54 unidades activas",
        "choferes": "59 taxistas censados",
        "seguro": "Póliza Colectiva • Seguros Unidos",
        "siniestrosHoy": "1 caso reportado hoy",
        "contacto": "Sr. Patricio Enríquez (Secretario)",
        "telefono": "+593 99 778 1122",
        "color": const Color(0xFFE65100),
      },
      {
        "nombre": "Coop. 24 de Mayo",
        "tipo": "Taxis Convencionales Sur",
        "unidades": "35 unidades activas",
        "choferes": "40 taxistas censados",
        "seguro": "Póliza Colectiva • Seguros Alianza",
        "siniestrosHoy": "1 caso reportado hoy",
        "contacto": "Lcdo. Fausto Guayasamín (Presidente)",
        "telefono": "+593 96 332 7788",
        "color": const Color(0xFF6A1B9A),
      },
    ];

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: coops.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildCoopCard(context, coops[index], isMobile: true),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.7,
      ),
      itemCount: coops.length,
      itemBuilder: (context, index) => _buildCoopCard(context, coops[index], isMobile: false),
    );
  }

  Widget _buildCoopCard(BuildContext context, Map<String, dynamic> c, {required bool isMobile}) {
    final color = c["color"] as Color;
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(Icons.local_taxi_rounded, color: color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c["nombre"] as String, style: ubuntuBold.copyWith(fontSize: 14), overflow: TextOverflow.ellipsis),
                          Text(c["tipo"] as String, style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text("Convenio Activo", style: ubuntuBold.copyWith(color: const Color(0xFF2E7D32), fontSize: 10)),
              ),
            ],
          ),
          const Divider(height: 16),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _detailItem("Flota Registrada", c["unidades"] as String)),
                    Expanded(child: _detailItem("Choferes", c["choferes"] as String)),
                  ],
                ),
                const SizedBox(height: 6),
                _detailItem("Seguro Vehicular", c["seguro"] as String),
                const SizedBox(height: 6),
                _detailItem("Contacto Directiva", "${c["contacto"]} • ${c["telefono"]}"),
              ],
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _detailItem("Flota Registrada", c["unidades"] as String)),
                      Expanded(child: _detailItem("Choferes", c["choferes"] as String)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _detailItem("Seguro Vehicular", c["seguro"] as String),
                  const SizedBox(height: 6),
                  _detailItem("Contacto Directiva", "${c["contacto"]} • ${c["telefono"]}"),
                ],
              ),
            ),
          const SizedBox(height: 10),
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c["siniestrosHoy"] as String, style: ubuntuMedium.copyWith(fontSize: 11, color: color)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          textStyle: ubuntuMedium.copyWith(fontSize: 11),
                        ),
                        onPressed: () {
                          Get.snackbar(
                            c["nombre"] as String,
                            "Descargando nómina oficial de vehículos y taxistas...",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text("Padrón de Taxis"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          textStyle: ubuntuMedium.copyWith(fontSize: 11),
                        ),
                        onPressed: () {
                          Get.snackbar(
                            "Contactar Directiva",
                            "Marcando a ${c["contacto"]}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: color,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text("Llamar"),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(c["siniestrosHoy"] as String, style: ubuntuMedium.copyWith(fontSize: 11, color: color)),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: ubuntuMedium.copyWith(fontSize: 11),
                      ),
                      onPressed: () {
                        Get.snackbar(
                          c["nombre"] as String,
                          "Descargando nómina oficial de vehículos y taxistas...",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                        );
                      },
                      child: const Text("Padrón de Taxis"),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: ubuntuMedium.copyWith(fontSize: 11),
                      ),
                      onPressed: () {
                        Get.snackbar(
                          "Contactar Directiva",
                          "Marcando a ${c["contacto"]}",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: color,
                          colorText: Colors.white,
                        );
                      },
                      child: const Text("Llamar"),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ubuntuRegular.copyWith(fontSize: 10, color: Colors.grey.shade600)),
        Text(value, style: ubuntuMedium.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
