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
import '../widgets/legal_mobile_nav_header.dart';

class LegalDocumentsScreen extends StatefulWidget {
  const LegalDocumentsScreen({super.key});

  @override
  State<LegalDocumentsScreen> createState() => _LegalDocumentsScreenState();
}

class _LegalDocumentsScreenState extends State<LegalDocumentsScreen> {
  late LegalCenterController controller;
  int _selectedTemplateIndex = 0;

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
              if (sub.route == RouteHelper.getLegalDocumentsRoute()) {
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
          activeIndex: 4,
          title: "Dictámenes & Actas",
          subtitle: "Expedientes y generación de actas",
        ),
        body: GetBuilder<LegalCenterController>(
          builder: (ctrl) {
            final currentCase = ctrl.selectedCase ??
                (ctrl.allCases.isNotEmpty ? ctrl.allCases.first : null);
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
                    _buildCaseSelector(context, ctrl, currentCase),
                    const SizedBox(height: 12),
                    _buildDocumentEditorArea(context, currentCase),
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
                        final currentCase = ctrl.selectedCase ?? (ctrl.allCases.isNotEmpty ? ctrl.allCases.first : null);
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
                              _buildCaseSelector(context, ctrl, currentCase),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              _buildDocumentEditorArea(context, currentCase),
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

  Widget _buildHeader(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_rounded, color: Colors.white, size: isMobile ? 22 : 28),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Centro Documental Legal • Dictámenes y Actas Inmediatas",
                  style: ubuntuBold.copyWith(
                    color: Colors.white,
                    fontSize: isMobile ? Dimensions.fontSizeDefault : Dimensions.fontSizeLarge,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Generación automatizada de descargos, actas de no retención vehicular (Art. 380 COIP) y conciliación extrajudicial.",
                  style: ubuntuRegular.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: isMobile ? Dimensions.fontSizeExtraSmall : Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseSelector(BuildContext context, LegalCenterController ctrl, LegalCase? currentCase) {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync_alt_rounded, color: Color(0xFF7B1FA2), size: 18),
                const SizedBox(width: 8),
                Text("Caso Vinculado para Autorelleno:", style: ubuntuBold.copyWith(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: ctrl.allCases.map((c) {
                  final isSelected = currentCase?.id == c.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text("${c.id} • ${c.taxistaNombre} (${c.placa})"),
                      labelStyle: ubuntuMedium.copyWith(
                        fontSize: 11,
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      selectedColor: const Color(0xFF7B1FA2),
                      onSelected: (_) => ctrl.selectCase(c),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_alt_rounded, color: Color(0xFF7B1FA2), size: 22),
          const SizedBox(width: 10),
          Text("Caso Vinculado para Autorelleno:", style: ubuntuBold.copyWith(fontSize: 12)),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: ctrl.allCases.map((c) {
                  final isSelected = currentCase?.id == c.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text("${c.id} • ${c.taxistaNombre} (${c.placa})"),
                      labelStyle: ubuntuMedium.copyWith(
                        fontSize: 11,
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      selectedColor: const Color(0xFF7B1FA2),
                      onSelected: (_) => ctrl.selectCase(c),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentEditorArea(BuildContext context, LegalCase? c) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final templates = [
      {
        "titulo": "Acta de Entrega Inmediata (Art. 380 COIP)",
        "sub": "Impide retención en patio si no hay heridos y documentos están al día",
        "icon": Icons.car_repair_rounded,
        "content": _generateActaEntrega(c),
      },
      {
        "titulo": "Acta Transaccional de Conciliación en Vía",
        "sub": "Acuerdo directo de reparación de daños materiales mutuos",
        "icon": Icons.handshake_rounded,
        "content": _generateActaConciliacion(c),
      },
      {
        "titulo": "Escrito de Impugnación de Tránsito",
        "sub": "Presentación formal de descargo ante Juez competente (Art. 389 COIP)",
        "icon": Icons.gavel_rounded,
        "content": _generateImpugnacion(c),
      },
      {
        "titulo": "Oficio Requerimiento de Cámaras ECU-911",
        "sub": "Solicitud legal de preservación y cadena de custodia de videos viales",
        "icon": Icons.videocam_rounded,
        "content": _generateOficioECU(c),
      },
    ];

    final activeDoc = templates[_selectedTemplateIndex];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text("Plantillas Legales Disponibles", style: ubuntuBold.copyWith(fontSize: 12)),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: templates.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final t = entry.value;
                      final isSel = _selectedTemplateIndex == idx;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: Icon(
                            t["icon"] as IconData,
                            size: 16,
                            color: isSel ? Colors.white : const Color(0xFF7B1FA2),
                          ),
                          selected: isSel,
                          label: Text(t["titulo"] as String),
                          labelStyle: ubuntuMedium.copyWith(
                            fontSize: 11,
                            color: isSel ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          selectedColor: const Color(0xFF7B1FA2),
                          onSelected: (_) => setState(() => _selectedTemplateIndex = idx),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildDocumentViewer(context, activeDoc, c, isMobile: true),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector lateral de plantillas
        Expanded(
          flex: 2,
          child: _buildDesktopTemplateList(templates),
        ),
        const SizedBox(width: 14),
        // Visor y acciones del documento
        Expanded(
          flex: 4,
          child: _buildDocumentViewer(context, activeDoc, c, isMobile: false),
        ),
      ],
    );
  }

  Widget _buildDesktopTemplateList(List<Map<String, dynamic>> templates) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text("Plantillas Legales Homologadas", style: ubuntuBold.copyWith(fontSize: 13)),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templates.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, idx) {
              final t = templates[idx];
              final isSel = _selectedTemplateIndex == idx;
              return InkWell(
                onTap: () => setState(() => _selectedTemplateIndex = idx),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  color: isSel ? const Color(0xFF7B1FA2).withValues(alpha: 0.08) : Colors.transparent,
                  child: Row(
                    children: [
                      Icon(t["icon"] as IconData, color: isSel ? const Color(0xFF7B1FA2) : Colors.grey, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t["titulo"] as String, style: ubuntuBold.copyWith(fontSize: 12, color: isSel ? const Color(0xFF7B1FA2) : null)),
                            const SizedBox(height: 2),
                            Text(t["sub"] as String, style: ubuntuRegular.copyWith(fontSize: 10, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentViewer(BuildContext context, Map<String, dynamic> activeDoc, LegalCase? c, {required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeDoc["titulo"] as String,
                  style: ubuntuBold.copyWith(fontSize: 14, color: const Color(0xFF4A148C)),
                ),
                const SizedBox(height: 2),
                Text(
                  "Generado dinámicamente para ${c?.id ?? 'Caso General'}",
                  style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.copy_rounded, size: 14),
                        label: const Text("Copiar"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          textStyle: ubuntuMedium.copyWith(fontSize: 11),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: activeDoc["content"] as String));
                          Get.snackbar(
                            "Texto Copiado",
                            "Plantilla copiada al portapapeles con éxito",
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
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                        label: const Text("Descargar PDF"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B1FA2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          textStyle: ubuntuMedium.copyWith(fontSize: 11),
                        ),
                        onPressed: () {
                          Get.snackbar(
                            "Generando PDF Formal",
                            "Preparando documento membretado con firma electrónica...",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF4A148C),
                            colorText: Colors.white,
                          );
                        },
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activeDoc["titulo"] as String, style: ubuntuBold.copyWith(fontSize: 15, color: const Color(0xFF4A148C))),
                      Text("Generado dinámicamente con los datos de ${c?.id ?? 'Caso General'}", style: ubuntuRegular.copyWith(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 14),
                      label: const Text("Copiar"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        textStyle: ubuntuMedium.copyWith(fontSize: 11),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: activeDoc["content"] as String));
                        Get.snackbar("Texto Copiado", "Plantilla copiada al portapapeles con éxito", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black87, colorText: Colors.white);
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                      label: const Text("Descargar PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: ubuntuMedium.copyWith(fontSize: 11),
                      ),
                      onPressed: () {
                        Get.snackbar("Generando PDF Formal", "Preparando documento membretado con firma electrónica...", snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF4A148C), colorText: Colors.white);
                      },
                    ),
                  ],
                ),
              ],
            ),
          const Divider(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SelectableText(
              activeDoc["content"] as String,
              style: ubuntuRegular.copyWith(fontSize: 12, height: 1.5, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  String _generateActaEntrega(LegalCase? c) {
    final driver = c?.taxistaNombre ?? '[NOMBRE TAXISTA]';
    final ci = c?.taxistaCedula ?? '[CÉDULA]';
    final coop = c?.cooperativa ?? '[COOPERATIVA]';
    final placa = c?.placa ?? '[PLACA]';
    final unidad = c?.unidad ?? '[UNIDAD]';
    final dir = c?.ubicacionDireccion ?? '[LUGAR DEL SINIESTRO]';

    return """ACTA DE ENTREGA INMEDIATA DE VEHÍCULO EN FLAGRANCIA
(Conforme al Artículo 380, inciso 3 del Código Orgánico Integral Penal - COIP)

En el Distrito Metropolitano de Quito, lugar: $dir.

Comparece el señor(a) $driver, con cédula de ciudadanía No. $ci, en su calidad de conductor profesional del vehículo tipo taxi perteneciente a $coop, $unidad, con placas de identificación vehicular $placa.

FUNDAMENTO DE DERECHO:
El artículo 380 inciso tercero del Código Orgánico Integral Penal establece expresamente que:
"En los accidentes de tránsito donde existan únicamente daños materiales y los vehículos se encuentren en condiciones mecánicas para circular, el agente de tránsito NO RETENDRÁ los automotores, procediendo a su entrega inmediata al conductor o propietario, previa fijación fotográfica y verificación documental de matrícula y seguro obligatorio".

DECLARACIÓN DE CONDICIONES:
1. El siniestro vial no involucra personas lesionadas ni pérdida de vidas humanas.
2. El automotor $placa cuenta con matrícula vigente y póliza SPPAT/Seguro al día.
3. El conductor suscribe la presente acta constituyéndose en custodio civil del automotor, comprometiéndose a ponerlo a disposición de la autoridad judicial en caso de requerimiento pericial posterior.

Por lo expuesto, el Agente Civil de Tránsito actuante procede a la ENTREGA INMEDIATA del automotor, absteniéndose de ordenar su traslado a los Patios de Retención Vehicular.

Firmado en unidad de acto:

___________________________               ___________________________
$driver                                   Abogado Defensor LegalTech
C.I. $ci                                  Matrícula Foro de Abogados
Conductor Profesional""";
  }

  String _generateActaConciliacion(LegalCase? c) {
    final driver = c?.taxistaNombre ?? '[CONDUCTOR TAXI]';
    final coop = c?.cooperativa ?? '[COOPERATIVA]';
    final placa = c?.placa ?? '[PLACA TAXI]';
    final incidente = c?.tipoIncidente ?? '[TIPO DE SINIESTRO]';
    final dir = c?.ubicacionDireccion ?? '[DIRECCIÓN]';

    return """ACTA TRANSACCIONAL Y DESISTIMIENTO EXTRAJUDICIAL EN VÍA
(Conforme a los Arts. 2348 y 2362 del Código Civil Ecuatoriano)

LUGAR Y FECHA: $dir, Quito - Ecuador.
INCIDENTE REPORTADO: $incidente.

COMPARECIENTES:
De una parte, el señor(a) $driver, conductor de la unidad de taxi placas $placa, perteneciente a $coop.
De otra parte, el conductor/propietario del vehículo particular involucrado.

CLÁUSULA PRIMERA: ANTECEDENTES Y DAÑOS
Las partes declaran que con fecha de hoy se produjo un siniestro de tránsito de tipología con daños exclusivamente materiales leves que no comprometen la integridad física de ninguna persona.

CLÁUSULA SEGUNDA: ACUERDO ECONÓMICO Y REPARACIÓN
Por mutuo acuerdo y con asistencia del departamento jurídico LegalTech, las partes acuerdan la reparación satisfactoria de los daños materiales sin necesidad de judicializar el hecho ni dar lugar a la retención de las unidades por parte de los Agentes Civiles de Tránsito.

CLÁUSULA TERCERA: RENUNCIA Y FINIQUITO
Las partes declaran no tener nada más que reclamarse en el presente ni en el futuro, renunciando a interponer denuncias, acusaciones particulares o demandas civiles o contravencionales.

Para constancia firman:

___________________________               ___________________________
$driver                                   Conductor Vehículo Tercero
Taxista Afiliado a $coop                  C.I. Identificación Particular""";
  }

  String _generateImpugnacion(LegalCase? c) {
    final driver = c?.taxistaNombre ?? '[CONDUCTOR]';
    final ci = c?.taxistaCedula ?? '[CÉDULA]';
    final coop = c?.cooperativa ?? '[COOPERATIVA]';
    final placa = c?.placa ?? '[PLACA]';
    final art = c?.articuloCoip ?? 'Art. 389 COIP';

    return """SEÑOR JUEZ DE LA UNIDAD JUDICIAL ESPECIALIZADA DE TRÁNSITO DE QUITO

$driver, con C.I. $ci, conductor profesional de $coop, unidad con placas $placa, con patrocinio del consultorio jurídico LegalTech, ante usted respetuosamente comparezco:

I. IMPUGNACIÓN OPORTUNA:
Dentro del término perentorio de tres (3) días contemplado en el Art. 644 del Código Orgánico Integral Penal, interpongo formal IMPUGNACIÓN a la boleta de citación contravencional emitida de manera arbitraria e infundada bajo la presunción del $art.

II. FUNDAMENTOS DE HECHO:
El día del presunto cometimiento de la infracción, me encontraba prestando servicio público regular. El agente actuante incurrió en error de apreciación manifiesta al sancionar una maniobra autorizada por desvío de flujo vehicular.

III. PRUEBA ANUNCIADA:
1. Grabación de videocámara vehicular (dashcam) que demuestra la inexistencia de la conducta típica.
2. Certificado de operación y habilitación de $coop.
3. Copia certificada del reporte de asistencia jurídica en vía.

Por lo expuesto, solicito se sirva convocar a audiencia de juzgamiento y declarar la nulidad e inocencia ratificada.

___________________________               ___________________________
$driver                                   Abogado Patrocinador
C.I. $ci                                  LegalTech Asistencia Jurídica""";
  }

  String _generateOficioECU(LegalCase? c) {
    final caso = c?.id ?? '#CASO-SINIESTRO';
    final dir = c?.ubicacionDireccion ?? '[DIRECCIÓN]';
    final hora = c?.horaReporte ?? '[HORA]';

    return """OFICIO JURÍDICO No. LT-ECU911-2026-088

PARA: Servicio Integrado de Seguridad ECU-911 / Agencia Metropolitana de Tránsito
DE: Departamento Legal y Pericial LegalTech
ASUNTO: Solicitud urgente de Cadena de Custodia y Respaldo de Grabaciones Viales
REF: Expediente $caso

De nuestra consideración:

Por medio de la presente, al amparo del Art. 76 numeral 7 literales a) y b) de la Constitución de la República del Ecuador, solicito de manera formal y urgente se sirva DISPONER a quien corresponda la PRESERVACIÓN, EXTRACCIÓN Y CUSTODIA de las grabaciones de las cámaras de videovigilancia ubicadas en el perímetro de:

UBICACIÓN DE LAS CÁMARAS: $dir.
HORA APROXIMADA DEL SINIESTRO: $hora.

Dichas grabaciones constituyen elemento probatorio esencial para el esclarecimiento de responsabilidades en el siniestro de tránsito vial que involucra a una unidad de transporte legal de taxi.

Agradecemos su pronta atención conforme a los plazos procesales de flagrancia.

Atentamente,

_________________________________________
Coordinación de Litigio Vial LegalTech
Asistencia Jurídica para Cooperativas de Transporte""";
  }
}
