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

                    // 1.5. TARJETA ESPECIALIZADA "OTRO PROBLEMA" (CIVIL, LABORAL, FINIQUITOS, ETC.)
                    if (caseItem.isOtroProblema) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.gavel_rounded, color: Color(0xFF7C3AED), size: 18),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Detalle de la Consulta Legal • "Otro Problema"',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF6D28D9),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Civil / Laboral',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF5B21B6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              caseItem.descripcionDetalladaCliente,
                              style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                height: 1.45,
                                color: const Color(0xFF4C1D95),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

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
                          // Badge de la Alerta (4 categorías acordadas)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: c.tipoAlerta.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: c.tipoAlerta.color),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(c.tipoAlerta.icon, size: 11, color: c.tipoAlerta.color),
                                const SizedBox(width: 4),
                                Text(
                                  c.tipoAlerta.label,
                                  style: ubuntuBold.copyWith(
                                    fontSize: 10,
                                    color: c.tipoAlerta.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${c.tipoIncidente} • ${c.canton}, ${c.provincia}',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodySmall?.color,
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
          const SizedBox(height: 12),
          _buildMembershipStatusBadge(context, c),
        ],
      ),
    );
  }

  Widget _buildMembershipStatusBadge(BuildContext context, LegalCase c) {
    if (c.esPruebaGratuita) {
      final ratio = (c.consultasGratuitasRestantes / (c.consultasGratuitasTotales > 0 ? c.consultasGratuitasTotales : 10)).clamp(0.0, 1.0);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.card_giftcard_rounded, size: 16, color: Color(0xFF1D4ED8)),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Usuario en Periodo de Prueba Gratuita (Piloto Ibarra)',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D4ED8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2563EB)),
                  ),
                  child: Text(
                    '${c.consultasGratuitasRestantes} de ${c.consultasGratuitasTotales} restantes',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 5,
                backgroundColor: const Color(0xFFDBEAFE),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            ),
          ],
        ),
      );
    }

    if (!c.isMembresiaActiva) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.4)),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFB91C1C)),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                '🔴 Membresía Vencida • Pendiente de Regularización',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB91C1C),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (c.asistenciaCondicionadaAutorizada) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD97706)),
        ),
        child: const Row(
          children: [
            Icon(Icons.shield_rounded, size: 16, color: Color(0xFFB45309)),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                '🛡️ Cobertura Condicionada Autorizada por Director Legal (Dr. Emir Vásquez)',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFB45309),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF15803D)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              '⭐ Membresía Activa (Plan VIP 24/7) • Cobertura Legal Completa',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF15803D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
                          color: Theme.of(context).textTheme.bodySmall?.color,
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
