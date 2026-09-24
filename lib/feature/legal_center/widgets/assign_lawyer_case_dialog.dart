import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../model/legal_case_model.dart';
import '../controller/legal_center_controller.dart';

class AssignLawyerCaseDialog extends StatefulWidget {
  final Map<String, dynamic> lawyer;
  final Function({
    required String caseId,
    required bool isQueued,
    required String etaMinutes,
    required String mode,
    required String caseTitle,
  }) onConfirmAssignment;

  const AssignLawyerCaseDialog({
    super.key,
    required this.lawyer,
    required this.onConfirmAssignment,
  });

  @override
  State<AssignLawyerCaseDialog> createState() => _AssignLawyerCaseDialogState();
}

class _AssignLawyerCaseDialogState extends State<AssignLawyerCaseDialog> {
  late final LegalCenterController _controller;
  late bool _hasActiveCase;
  late String _activeCaseDetail;

  // Modo de asignación cuando ya tiene caso: 'queue' (encolar secundario) o 'immediate' (reasignación/despacho prioritario)
  String _assignmentMode = 'queue';
  String _selectedCaseId = '#CASO-1042';
  String _selectedEta = '12';

  // Lista combinada de casos seleccionables para la asignación
  late List<_CaseOption> _availableCases;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<LegalCenterController>()
        ? Get.find<LegalCenterController>()
        : Get.put(LegalCenterController());

    final estado = (widget.lawyer['estado'] ?? '').toString().toLowerCase();
    _hasActiveCase = estado.contains('camino') ||
        estado.contains('audiencia') ||
        estado.contains('caso') ||
        estado.contains('atención');

    _activeCaseDetail = widget.lawyer['estado'] ?? 'En atención';

    // Si ya tiene caso, por defecto sugerir 'queue' (encolar secundario para no interrumpir)
    // Si no tiene caso, modo directo 'immediate'
    _assignmentMode = _hasActiveCase ? 'queue' : 'immediate';

    _prepareCaseOptions();
  }

  void _prepareCaseOptions() {
    final list = <_CaseOption>[];

    // Obtener casos reales no asignados o pendientes desde el controlador
    for (final c in _controller.allCases) {
      if (c.estado == CaseStatus.pendiente ||
          c.abogadoAsignado == null ||
          c.abogadoAsignado!.isEmpty) {
        list.add(_CaseOption(
          id: c.id,
          conductor: c.taxistaNombre,
          cooperativa: c.cooperativa,
          tipoIncidente: c.tipoIncidente,
          ubicacion: '${c.canton} • ${c.ubicacionDireccion}',
          alertaNivel: c.alertaNivel,
          esCritico: c.tieneHeridosORetencion,
          dictamenIa: c.dictamenIaCorto,
        ));
      }
    }

    // Asegurar siempre opciones representativas para demo interactivo
    if (!list.any((c) => c.id == '#CASO-1042')) {
      list.add(const _CaseOption(
        id: '#CASO-1042',
        conductor: 'Carlos M. Mendoza',
        cooperativa: 'Los Lagos (Unidad 42)',
        tipoIncidente: 'Colisión Lateral / Intento de Retención en Patio',
        ubicacion: 'Otavalo • Panamericana Norte y Redondel',
        alertaNivel: AlertaNivel.critico,
        esCritico: true,
        dictamenIa: 'Art. 380 COIP: No conciliar sin SIAT • Entrega sin patio',
      ));
    }

    if (!list.any((c) => c.id == '#CASO-1044')) {
      list.add(const _CaseOption(
        id: '#CASO-1044',
        conductor: 'Wilson Patricio Guanoluisa',
        cooperativa: 'Flota Imbabura (Unidad 18)',
        tipoIncidente: 'Choque por Alcance con Agresión de Tercero',
        ubicacion: 'Ibarra • Av. Cristóbal de Troya y Fray Vacas',
        alertaNivel: AlertaNivel.critico,
        esCritico: true,
        dictamenIa: 'Art. 379 COIP: Custodia de conductor y valoración SPPAT',
      ));
    }

    if (!list.any((c) => c.id == '#CASO-1047')) {
      list.add(const _CaseOption(
        id: '#CASO-1047',
        conductor: 'Manuel E. Farinango',
        cooperativa: 'Coop. El Tejar (Unidad 07)',
        tipoIncidente: 'Rozamiento en Cruce con Negativa a Indemnizar',
        ubicacion: 'Cotacachi • Calle Bolívar y Sucre',
        alertaNivel: AlertaNivel.regular,
        esCritico: false,
        dictamenIa: 'Art. 380 COIP: Mediación extrajudicial directa con finiquito',
      ));
    }

    _availableCases = list;
    if (_availableCases.isNotEmpty) {
      _selectedCaseId = _availableCases.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lawyerName = widget.lawyer['nombre'] ?? 'Abogado Móvil';
    final lawyerUnit = widget.lawyer['unidad'] ?? 'Unidad Móvil';
    final lawyerCar = widget.lawyer['vehiculo'] ?? 'Vehículo patrulla';
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
        width: isMobile ? double.infinity : 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.all(isMobile ? 14 : Dimensions.paddingSizeLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera del Diálogo
            _buildDialogHeader(lawyerName, lawyerUnit, lawyerCar),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            const Divider(height: 1),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Contenido con Scroll
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner de Estado: Alerta de caso activo vs Unidad libre
                    _buildStatusBanner(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Selector de Modo (solo si ya tiene caso activo)
                    if (_hasActiveCase) ...[
                      _buildAssignmentModeSelector(),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ],

                    // Lista de Casos Pendientes
                    Text(
                      '1. Seleccione el Siniestro / Incidente a Despachar:',
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Casos en cola priorizados por cercanía territorial y criticidad legal:',
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    _buildCaseList(),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    // Selector de ETA y SLA de Arribo
                    _buildEtaSelector(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeSmall),
            const Divider(height: 1),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Barra de Acciones
            _buildActionButtons(context, lawyerName),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader(String name, String unit, String car) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.assignment_ind_rounded, color: Color(0xFF0D47A1), size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asignar Caso a $name',
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$unit • $car',
                style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded, size: 20),
          splashRadius: 18,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildStatusBanner() {
    if (_hasActiveCase) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFB74D)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Abogado con Asignación Activa',
                    style: ubuntuBold.copyWith(
                      color: const Color(0xFFE65100),
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Actualmente en estado: "$_activeCaseDetail". Puedes encolar este nuevo caso para que sea atendido automáticamente al finalizar su gestión, o forzar reasignación inmediata en caso de emergencia Código Rojo.',
                    style: ubuntuRegular.copyWith(
                      color: const Color(0xFF5D4037),
                      fontSize: Dimensions.fontSizeSmall,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFA5D6A7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unidad Libre para Despacho Inmediato',
                  style: ubuntuBold.copyWith(
                    color: const Color(0xFF2E7D32),
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'El profesional se encuentra disponible en patrullaje o en guardia. El arribo al siniestro iniciará de forma instantánea al confirmar.',
                  style: ubuntuRegular.copyWith(
                    color: const Color(0xFF1B5E20),
                    fontSize: Dimensions.fontSizeSmall,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentModeSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modalidad de Gestión:',
            style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildModeOption(
                  mode: 'queue',
                  title: 'Encolar Caso Secundario',
                  subtitle: 'Atender al terminar caso activo (Recomendado)',
                  icon: Icons.queue_rounded,
                  color: const Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeOption(
                  mode: 'immediate',
                  title: 'Despacho Inmediato',
                  subtitle: 'Interrumpir y priorizar nuevo siniestro',
                  icon: Icons.priority_high_rounded,
                  color: const Color(0xFFC62828),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeOption({
    required String mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _assignmentMode == mode;
    return InkWell(
      onTap: () => setState(() => _assignmentMode = mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).dividerColor.withValues(alpha: 0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? color : Colors.grey,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 14, color: color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          title,
                          style: ubuntuBold.copyWith(
                            fontSize: 12,
                            color: isSelected ? color : Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: ubuntuRegular.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _availableCases.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = _availableCases[index];
        final isSelected = _selectedCaseId == item.id;

        return InkWell(
          onTap: () => setState(() => _selectedCaseId = item.id),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0D47A1).withValues(alpha: 0.05)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Theme.of(context).dividerColor.withValues(alpha: 0.15),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.id,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: const Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.esCritico
                                  ? const Color(0xFFFFEBEE)
                                  : const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.esCritico ? '🔴 Código Rojo' : '🟡 Pendiente',
                              style: ubuntuBold.copyWith(
                                fontSize: 9,
                                color: item.esCritico
                                    ? const Color(0xFFC62828)
                                    : const Color(0xFFF57F17),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.cooperativa,
                              textAlign: TextAlign.end,
                              style: ubuntuMedium.copyWith(
                                fontSize: 10,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.tipoIncidente,
                        style: ubuntuBold.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${item.conductor} • ${item.ubicacion}',
                              style: ubuntuRegular.copyWith(
                                fontSize: 11,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (item.dictamenIa != null && item.dictamenIa!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF056AB4).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'IA: ${item.dictamenIa!}',
                            style: ubuntuRegular.copyWith(
                              fontSize: 10,
                              color: const Color(0xFF056AB4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEtaSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '2. Tiempo Estimado de Arribo (ETA):',
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Meta SLA: < 15 min',
                  style: ubuntuBold.copyWith(fontSize: 10, color: const Color(0xFF6A1B9A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: ['6', '8', '12', '15', '20'].map((eta) {
              final isSel = _selectedEta == eta;
              return ChoiceChip(
                label: Text('$eta min'),
                selected: isSel,
                selectedColor: const Color(0xFF0D47A1),
                backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.05),
                labelStyle: ubuntuMedium.copyWith(
                  fontSize: 11,
                  color: isSel ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedEta = eta);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String lawyerName) {
    final isEnqueuing = _hasActiveCase && _assignmentMode == 'queue';
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Row(
      children: [
        if (isMobile)
          Expanded(
            flex: 2,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                textStyle: ubuntuMedium.copyWith(fontSize: 11),
              ),
              child: const Text('Cancelar'),
            ),
          )
        else ...[
          const Spacer(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: ubuntuMedium.copyWith(fontSize: 12),
            ),
            child: const Text('Cancelar'),
          ),
        ],
        const SizedBox(width: 8),
        Expanded(
          flex: isMobile ? 3 : 0,
          child: ElevatedButton.icon(
            icon: Icon(
              isEnqueuing ? Icons.queue_rounded : Icons.send_rounded,
              size: 14,
            ),
            label: Text(
              isEnqueuing
                  ? (isMobile ? 'Encolar Caso' : 'Encolar Caso Secundario')
                  : (isMobile ? 'Despachar Ahora' : 'Confirmar Despacho Inmediato'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnqueuing ? const Color(0xFF0D47A1) : const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 10),
              textStyle: ubuntuBold.copyWith(fontSize: isMobile ? 11 : 12),
            ),
            onPressed: () {
              final selected = _availableCases.firstWhere(
                (c) => c.id == _selectedCaseId,
                orElse: () => _availableCases.first,
              );

              widget.onConfirmAssignment(
                caseId: _selectedCaseId,
                isQueued: isEnqueuing,
                etaMinutes: _selectedEta,
                mode: _assignmentMode,
                caseTitle: selected.tipoIncidente,
              );

              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class _CaseOption {
  final String id;
  final String conductor;
  final String cooperativa;
  final String tipoIncidente;
  final String ubicacion;
  final AlertaNivel alertaNivel;
  final bool esCritico;
  final String? dictamenIa;

  const _CaseOption({
    required this.id,
    required this.conductor,
    required this.cooperativa,
    required this.tipoIncidente,
    required this.ubicacion,
    required this.alertaNivel,
    required this.esCritico,
    this.dictamenIa,
  });
}
