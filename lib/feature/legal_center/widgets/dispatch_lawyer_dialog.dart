import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../model/legal_case_model.dart';
import '../controller/legal_center_controller.dart';

class DispatchLawyerDialog extends StatefulWidget {
  final LegalCase caseItem;

  const DispatchLawyerDialog({super.key, required this.caseItem});

  @override
  State<DispatchLawyerDialog> createState() => _DispatchLawyerDialogState();
}

class _DispatchLawyerDialogState extends State<DispatchLawyerDialog> {
  final List<Map<String, String>> lawyers = [
    {
      'name': 'Dr. Marcelo Dávila',
      'specialty': 'Derecho Penal & Tránsito • Unidad Móvil #1',
      'distance': 'A 3.2 km • Tiempo estimado: 8 min',
      'status': 'Disponible en guardia',
    },
    {
      'name': 'Dra. Elena Torres',
      'specialty': 'Litigio Flagrancias • Unidad Móvil #2',
      'distance': 'A 5.8 km • Tiempo estimado: 15 min',
      'status': 'Disponible en guardia',
    },
    {
      'name': 'Dr. Fernando Salazar',
      'specialty': 'Contravenciones & Mediación SIAT • Unidad Móvil #3',
      'distance': 'A 7.1 km • Tiempo estimado: 20 min',
      'status': 'Disponible en guardia',
    },
  ];

  late int selectedLawyerIndex;
  String arrivalMinutes = '12';

  @override
  void initState() {
    super.initState();
    selectedLawyerIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.directions_car_filled, color: Color(0xFF1565C0), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Despachar Abogado Móvil',
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          Text(
                            'Asignación inmediata a siniestro de vía pública',
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Resumen del caso
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.caseItem.id} • ${widget.caseItem.cooperativa}',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          widget.caseItem.unidad,
                          style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Conductor: ${widget.caseItem.taxistaNombre} (${widget.caseItem.placa})',
                      style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.caseItem.ubicacionDireccion,
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Seleccionar Abogado de Guardia:',
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 10),

              // Lista de abogados
              ...List.generate(lawyers.length, (index) {
                final lawyer = lawyers[index];
                final isSelected = selectedLawyerIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedLawyerIndex = index;
                      if (index == 0) arrivalMinutes = '8';
                      if (index == 1) arrivalMinutes = '15';
                      if (index == 2) arrivalMinutes = '20';
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    lawyer['name']!,
                                    style: ubuntuBold.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      lawyer['status']!,
                                      style: ubuntuMedium.copyWith(
                                        fontSize: 10,
                                        color: const Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lawyer['specialty']!,
                                style: ubuntuRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodySmall!.color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 13, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    lawyer['distance']!,
                                    style: ubuntuMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancelar',
                      style: ubuntuMedium.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    label: Text(
                      'Confirmar Despacho Inmediato',
                      style: ubuntuBold.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      final selectedLawyer = lawyers[selectedLawyerIndex]['name']!;
                      Get.find<LegalCenterController>().dispatchLawyer(
                        widget.caseItem.id,
                        selectedLawyer,
                        arrivalMinutes,
                      );
                      Get.back();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
