import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../model/legal_case_model.dart';
import '../controller/legal_center_controller.dart';

class LegalEscalationDialog extends StatefulWidget {
  final TerritoryLawyer lawyer;
  final String? initialReason;

  const LegalEscalationDialog({
    super.key,
    required this.lawyer,
    this.initialReason,
  });

  static void show(
    BuildContext context,
    TerritoryLawyer lawyer, {
    String? initialReason,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LegalEscalationDialog(
        lawyer: lawyer,
        initialReason: initialReason,
      ),
    );
  }

  @override
  State<LegalEscalationDialog> createState() => _LegalEscalationDialogState();
}

class _LegalEscalationDialogState extends State<LegalEscalationDialog> {
  String? selectedDestinationLawyer;
  late String selectedReason;

  final List<String> reasons = [
    'Tiempo de respuesta SLA excedido (>15 min)',
    'El abogado ya no se encuentra asociado a la red',
    'Abogado ocupado en audiencia sobrevenida',
    'Falla de comunicación o sin cobertura en vía',
    'Siniestro de alta complejidad requiere refuerzo penal',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialReason != null && reasons.contains(widget.initialReason)) {
      selectedReason = widget.initialReason!;
    } else {
      selectedReason = reasons.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalCenterController>();

    // Abogados disponibles y activos para recibir la transferencia (excepto el actual y excluyendo no asociados)
    final candidateLawyers = controller.allLawyers
        .where((l) =>
            l.nombre != widget.lawyer.nombre &&
            l.estadoGuardia != LawyerGuardStatus.noAsociado)
        .toList();

    if (selectedDestinationLawyer == null && candidateLawyers.isNotEmpty) {
      // Priorizar uno que esté en línea
      final available = candidateLawyers.firstWhereOrNull(
            (l) => l.estadoGuardia == LawyerGuardStatus.enLinea,
          ) ??
          candidateLawyers.first;
      selectedDestinationLawyer = available.nombre;
    }

    // Casos activos asignados a este abogado
    final activeCases = controller.allCases
        .where((c) =>
            c.abogadoAsignado == widget.lawyer.nombre &&
            c.estado != CaseStatus.atendido)
        .toList();

    final isDisassociated = selectedReason.contains('asociado');
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      child: Container(
        width: isMobile ? double.infinity : 520,
        padding: EdgeInsets.all(isMobile ? 12 : Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDisassociated
                        ? const Color(0xFFECEFF1)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDisassociated
                        ? Icons.sync_alt_rounded
                        : Icons.flash_on_rounded,
                    color: isDisassociated
                        ? const Color(0xFF455A64)
                        : const Color(0xFFD32F2F),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDisassociated
                            ? 'Remisión y Desvinculación de Casos'
                            : 'Escalamiento Directo de Casos',
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: isDisassociated
                              ? const Color(0xFF37474F)
                              : const Color(0xFFD32F2F),
                        ),
                      ),
                      Text(
                        isDisassociated
                            ? 'Reasignación definitiva por desvinculación del profesional'
                            : 'Reasignación urgente por falta de respuesta oportuna',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 20),

            // INFORMACIÓN DEL ABOGADO ACTUAL
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 20, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abogado actual: ${widget.lawyer.nombre}',
                          style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(
                          'Cantón: ${widget.lawyer.canton} • ${widget.lawyer.estadoLabel}',
                          style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: widget.lawyer.estadoColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: activeCases.isNotEmpty
                          ? const Color(0xFFFFEBEE)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${activeCases.length} caso(s) activos',
                      style: ubuntuBold.copyWith(
                        fontSize: 11,
                        color: activeCases.isNotEmpty
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // MOTIVO DE ESCALAMIENTO / REMISIÓN
            Text(
              'Motivo del Escalamiento o Remisión:',
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDisassociated
                      ? const Color(0xFF78909C)
                      : Theme.of(context).dividerColor,
                  width: isDisassociated ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedReason,
                  items: reasons.map((r) {
                    final isOptionDisassoc = r.contains('asociado');
                    return DropdownMenuItem<String>(
                      value: r,
                      child: Row(
                        children: [
                          if (isOptionDisassoc) ...[
                            const Icon(
                              Icons.person_remove_rounded,
                              size: 15,
                              color: Color(0xFF546E7A),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              r,
                              style: ubuntuRegular.copyWith(
                                fontSize: 12,
                                fontWeight: isOptionDisassoc
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isOptionDisassoc
                                    ? const Color(0xFF37474F)
                                    : Theme.of(context).textTheme.bodyLarge!.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedReason = val);
                  },
                ),
              ),
            ),

            // MENSAJE DE ADVERTENCIA SI ES DESVINCULACIÓN
            if (isDisassociated) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFECEFF1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB0BEC5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF455A64),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Al confirmar, ${widget.lawyer.nombre} pasará a estado "Ya no asociado" y no recibirá nuevas asignaciones en el territorio. Sus ${activeCases.length} caso(s) activos se remitirán de forma inmediata.',
                        style: ubuntuRegular.copyWith(
                          fontSize: 11,
                          color: const Color(0xFF37474F),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            // SELECCIÓN DE NUEVO ABOGADO DE GUARDIA
            Text(
              'Remitir inmediatamente a:',
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF1565C0)),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE3F2FD).withValues(alpha: 0.3),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedDestinationLawyer,
                  items: candidateLawyers.map((l) {
                    return DropdownMenuItem<String>(
                      value: l.nombre,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: l.estadoColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${l.nombre} (${l.canton}) • ${l.estadoLabel}',
                              style: ubuntuMedium.copyWith(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedDestinationLawyer = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOTONES
            Row(
              children: [
                if (isMobile)
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  )
                else ...[
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ],
                const SizedBox(width: 8),
                Expanded(
                  flex: isMobile ? 3 : 0,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDisassociated
                          ? const Color(0xFF455A64)
                          : const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: Icon(
                      isDisassociated
                          ? Icons.sync_alt_rounded
                          : Icons.flash_on_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    label: Text(
                      isDisassociated
                          ? (isMobile ? 'Desvincular' : 'Remitir Casos y Desvincular')
                          : (isMobile ? 'Escalar Ahora' : 'Confirmar Escalamiento Inmediato'),
                      style: ubuntuBold.copyWith(fontSize: isMobile ? 11 : 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      if (selectedDestinationLawyer != null) {
                        controller.escalateLawyerCases(
                          widget.lawyer.nombre,
                          selectedDestinationLawyer!,
                          reason: selectedReason,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
