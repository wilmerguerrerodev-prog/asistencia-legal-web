import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
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
      'name': 'Grupo Ecuador Total Abogados',
      'specialty': 'Despacho Jurídico Corporativo Central • Tránsito, Civil y Laboral',
      'distance': 'Central Jurídica (Sede Ibarra) • Atención Inmediata 24/7',
      'status': 'Despacho Corporativo',
      'isCorporate': 'true',
    },
    {
      'name': 'Dr. Marcelo Dávila',
      'specialty': 'Derecho Penal & Tránsito • Unidad Móvil #1',
      'distance': 'A 3.2 km • Tiempo estimado: 8 min',
      'status': 'Disponible en guardia',
      'isCorporate': 'false',
    },
    {
      'name': 'Dra. Elena Torres',
      'specialty': 'Litigio Flagrancias • Unidad Móvil #2',
      'distance': 'A 5.8 km • Tiempo estimado: 15 min',
      'status': 'Disponible en guardia',
      'isCorporate': 'false',
    },
    {
      'name': 'Dr. Fernando Salazar',
      'specialty': 'Contravenciones & Mediación SIAT • Unidad Móvil #3',
      'distance': 'A 7.1 km • Tiempo estimado: 20 min',
      'status': 'Disponible en guardia',
      'isCorporate': 'false',
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
    final mediaQuery = MediaQuery.of(context);
    final isMobile = mediaQuery.size.width < 500;
    final maxDialogHeight = mediaQuery.size.height * 0.90;

    // Control de roles RBAC: Solo Director Legal o Admin TI pueden despachar unidades
    final auth = Get.isRegistered<AuthMockController>() ? Get.find<AuthMockController>() : null;
    final isAuthorizedToDispatch = auth == null || auth.isAdminLawyer || auth.isItAdmin;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 16 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: maxDialogHeight,
        ),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 12 : Dimensions.paddingSizeLarge),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header fijo
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.directions_car_filled, color: Color(0xFF1565C0), size: 22),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Despachar Abogado Móvil',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ubuntuBold.copyWith(
                            fontSize: isMobile ? Dimensions.fontSizeDefault : Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        Text(
                          'Asignación inmediata a siniestro de vía pública',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close),
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(height: 18),

              // Alerta de RBAC si el usuario no es Director Legal
              if (!isAuthorizedToDispatch) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFF87171)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 18, color: Color(0xFFDC2626)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Permiso Restringido: El despacho de unidades móviles corresponde exclusivamente al Director Legal o a la Central.',
                          style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: const Color(0xFF991B1B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 2. Contenido scrolleable
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Resumen del caso
                      Container(
                        padding: const EdgeInsets.all(10),
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
                                Expanded(
                                  child: Text(
                                    '${widget.caseItem.id} • ${widget.caseItem.cooperativa}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: ubuntuBold.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.caseItem.unidad,
                                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Conductor: ${widget.caseItem.taxistaNombre} (${widget.caseItem.placa})',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Icon(Icons.location_on, size: 14, color: Colors.red),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.caseItem.ubicacionDireccion,
                                    style: ubuntuRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context).textTheme.bodySmall!.color,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      Text(
                        'Seleccionar Abogado de Guardia:',
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Lista de abogados
                      ...List.generate(lawyers.length, (index) {
                        final lawyer = lawyers[index];
                        final isSelected = selectedLawyerIndex == index;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedLawyerIndex = index;
                              if (index == 0) arrivalMinutes = '5'; // Despacho Corporativo
                              if (index == 1) arrivalMinutes = '8';
                              if (index == 2) arrivalMinutes = '15';
                              if (index == 3) arrivalMinutes = '20';
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(isMobile ? 10 : 12),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, right: 8),
                                  child: Container(
                                    width: 18,
                                    height: 18,
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
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          Text(
                                            lawyer['name']!,
                                            style: ubuntuBold.copyWith(
                                              fontSize: isMobile ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                                              color: Theme.of(context).textTheme.bodyLarge!.color,
                                            ),
                                          ),
                                          Container(
                                            constraints: BoxConstraints(maxWidth: isMobile ? 180 : 240),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: lawyer['isCorporate'] == 'true'
                                                  ? const Color(0xFFEFF6FF)
                                                  : const Color(0xFFE8F5E9),
                                              borderRadius: BorderRadius.circular(4),
                                              border: lawyer['isCorporate'] == 'true'
                                                  ? Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.4))
                                                  : null,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (lawyer['isCorporate'] == 'true') ...[
                                                  const Icon(Icons.business_rounded, size: 10, color: Color(0xFF1D4ED8)),
                                                  const SizedBox(width: 3),
                                                ],
                                                Flexible(
                                                  child: Text(
                                                    lawyer['status']!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: ubuntuMedium.copyWith(
                                                      fontSize: 10,
                                                      fontWeight: lawyer['isCorporate'] == 'true'
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                      color: lawyer['isCorporate'] == 'true'
                                                          ? const Color(0xFF1D4ED8)
                                                          : const Color(0xFF2E7D32),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        lawyer['specialty']!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: ubuntuRegular.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context).textTheme.bodySmall!.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 1),
                                            child: Icon(
                                              lawyer['isCorporate'] == 'true' ? Icons.location_city_rounded : Icons.timer_outlined,
                                              size: 13,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              lawyer['distance']!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: ubuntuMedium.copyWith(
                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                color: Colors.blue.shade800,
                                              ),
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
                    ],
                  ),
                ),
              ),

              // 3. Botones de acción fijos en la base
              const SizedBox(height: 12),
              Row(
                children: [
                  if (isMobile) ...[
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Cancelar',
                            style: ubuntuMedium.copyWith(color: Theme.of(context).hintColor, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 15),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Despachar Ahora',
                            style: ubuntuBold.copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        onPressed: !isAuthorizedToDispatch
                            ? null
                            : () {
                                final selectedLawyer = lawyers[selectedLawyerIndex]['name']!;
                                final isCorporate = lawyers[selectedLawyerIndex]['isCorporate'] == 'true';
                                if (isCorporate || selectedLawyer.contains('Grupo Ecuador Total')) {
                                  Get.find<LegalCenterController>().dispatchToCorporateGroup(
                                    widget.caseItem.id,
                                  );
                                } else {
                                  Get.find<LegalCenterController>().dispatchLawyer(
                                    widget.caseItem.id,
                                    selectedLawyer,
                                    arrivalMinutes,
                                  );
                                }
                                Get.back();
                              },
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancelar',
                        style: ubuntuMedium.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                        label: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Confirmar Despacho',
                            style: ubuntuBold.copyWith(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        onPressed: !isAuthorizedToDispatch
                            ? null
                            : () {
                                final selectedLawyer = lawyers[selectedLawyerIndex]['name']!;
                                final isCorporate = lawyers[selectedLawyerIndex]['isCorporate'] == 'true';
                                if (isCorporate || selectedLawyer.contains('Grupo Ecuador Total')) {
                                  Get.find<LegalCenterController>().dispatchToCorporateGroup(
                                    widget.caseItem.id,
                                  );
                                } else {
                                  Get.find<LegalCenterController>().dispatchLawyer(
                                    widget.caseItem.id,
                                    selectedLawyer,
                                    arrivalMinutes,
                                  );
                                }
                                Get.back();
                              },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
