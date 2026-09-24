import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'legal_call_dialog.dart';

class LegalCaseDetailDialog extends StatelessWidget {
  final LegalCase caseItem;

  const LegalCaseDetailDialog({super.key, required this.caseItem});

  static void show(BuildContext context, LegalCase caseItem) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LegalCaseDetailDialog(caseItem: caseItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalCenterController>();
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: isMobile ? 16 : 24,
      ),
      child: Container(
        width: 760,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(
          children: [
            // CABECERA DEL MODAL
            _buildHeader(context, caseItem),

            // CONTENIDO CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. CONDUCTOR Y VEHÍCULO
                    _buildDriverSection(context, caseItem),

                    const SizedBox(height: 16),

                    // 2. DICTAMEN PRELIMINAR IA & ARTÍCULO COIP
                    _buildIaDiagnosisSection(context, caseItem),

                    const SizedBox(height: 16),

                    // 3. RELATO Y UBICACIÓN
                    _buildStoryAndLocation(context, caseItem),

                    const SizedBox(height: 16),

                    // 4. EVIDENCIAS ADJUNTAS
                    _buildEvidenceSection(context, caseItem),

                    const SizedBox(height: 16),

                    // 5. TRAZABILIDAD / LÍNEA DE TIEMPO
                    _buildTimelineSection(context, caseItem),
                  ],
                ),
              ),
            ),

            // BARRA INFERIOR DE ACCIÓN EJECUTIVA
            _buildFooterActions(context, controller, caseItem),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LegalCase c) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: c.alertaNivel.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: c.alertaNivel.color.withValues(alpha: 0.5)),
                  ),
                  child: Icon(c.alertaNivel.icon, color: c.alertaNivel.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            c.id,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: c.alertaNivel.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: c.alertaNivel.color),
                            ),
                            child: Text(
                              c.alertaNivel.label,
                              style: ubuntuBold.copyWith(
                                fontSize: 10,
                                color: c.alertaNivel.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${c.tipoIncidente} • ${c.canton}, ${c.provincia}',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverSection(BuildContext context, LegalCase c) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Datos del Conductor y Unidad',
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Text(
                  c.cooperativa,
                  style: ubuntuBold.copyWith(fontSize: 11, color: const Color(0xFFE65100)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 24,
            runSpacing: 10,
            children: [
              _infoItem(context, 'Conductor', c.taxistaNombre, Icons.person_outline),
              _infoItem(context, 'Cédula', c.taxistaCedula, Icons.badge_outlined),
              _infoItem(context, 'Teléfono', c.taxistaTelefono, Icons.phone_outlined),
              _infoItem(context, 'Unidad & Placa', '${c.unidad} • ${c.placa}', Icons.local_taxi_outlined),
              _infoItem(context, 'Vehículo', c.vehiculoModelo, Icons.directions_car_outlined),
              _infoItem(context, 'Seguro', c.estadoSeguro, Icons.shield_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(BuildContext context, String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: ubuntuRegular.copyWith(
                fontSize: 10,
                color: Theme.of(context).hintColor,
              ),
            ),
            Text(
              value,
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIaDiagnosisSection(BuildContext context, LegalCase c) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF056AB4).withValues(alpha: 0.08),
            const Color(0xFF0D47A1).withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF056AB4).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF056AB4), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dictamen Preliminar IA LegalTech',
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: const Color(0xFF056AB4),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF056AB4).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.balance, size: 14, color: Color(0xFF056AB4)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    c.articuloCoip,
                    style: ubuntuBold.copyWith(fontSize: 10, color: const Color(0xFF056AB4)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            c.dictamenIaRecomendacion,
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              height: 1.4,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryAndLocation(BuildContext context, LegalCase c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.place_outlined, size: 18, color: Color(0xFFD32F2F)),
            const SizedBox(width: 6),
            Text(
              'Ubicación del Siniestro: ',
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            Expanded(
              child: Text(
                '${c.ubicacionDireccion} (${c.canton})',
                style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Relato del Conductor en Calle:',
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: Theme.of(context).hintColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                c.relatoConductor,
                style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceSection(BuildContext context, LegalCase c) {
    if (c.evidencias.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencias Adjuntas (${c.evidencias.length})',
          style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: c.evidencias.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(e.icon, size: 18, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.title,
                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                      Text(
                        e.detail,
                        style: ubuntuRegular.copyWith(
                          fontSize: 9,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimelineSection(BuildContext context, LegalCase c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trazabilidad en Tiempo Real',
          style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        const SizedBox(height: 8),
        ...c.timeline.map((event) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: event.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(event.icon, size: 14, color: event.color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.time,
                            style: ubuntuRegular.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        event.description,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFooterActions(
    BuildContext context,
    LegalCenterController controller,
    LegalCase c,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          ),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 14, vertical: 10),
              ),
              icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
              label: Text(
                isMobile ? 'Llamar' : 'Llamada Rápida',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                LegalCallDialog.show(context, c);
              },
            ),
          ),
          const SizedBox(width: 8),
          if (c.estado == CaseStatus.pendiente) ...[
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 14, vertical: 10),
                ),
                icon: const Icon(Icons.verified_user_rounded, size: 16),
                label: Text(
                  isMobile ? 'Aprobar' : 'Aprobar Dictamen',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  controller.approveDictamen(c.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: 10),
              ),
              child: const Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
