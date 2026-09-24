import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../model/legal_case_model.dart';
import '../controller/legal_center_controller.dart';

class LegalCallDialog extends StatelessWidget {
  final LegalCase caseItem;

  const LegalCallDialog({super.key, required this.caseItem});

  static void show(BuildContext context, LegalCase caseItem) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LegalCallDialog(caseItem: caseItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalCenterController>();

    // Buscar teléfono del abogado asignado o el primero de guardia en el cantón
    String lawyerName = caseItem.abogadoAsignado ?? 'Sin abogado asignado';
    String lawyerPhone = '+593 99 445 1200';
    if (caseItem.abogadoAsignado != null) {
      final match = controller.allLawyers.firstWhereOrNull(
        (l) => l.nombre == caseItem.abogadoAsignado,
      );
      if (match != null) {
        lawyerPhone = match.telefono;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
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
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: Color(0xFF2E7D32),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Llamada Rápida de Emergencia',
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                        ),
                      ),
                      Text(
                        'Caso ${caseItem.id} • ${caseItem.cooperativa}',
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
            const Divider(height: 24),

            // OPCIÓN 1: LLAMAR AL CONDUCTOR
            _callOptionTile(
              context: context,
              title: 'Llamar al Conductor en Vía',
              subtitle: '${caseItem.taxistaNombre} (${caseItem.unidad})',
              phone: caseItem.taxistaTelefono,
              icon: Icons.person_rounded,
              iconColor: const Color(0xFF1565C0),
              badge: 'Conductor',
            ),

            const SizedBox(height: 12),

            // OPCIÓN 2: LLAMAR AL ABOGADO EN TERRITORIO
            _callOptionTile(
              context: context,
              title: 'Llamar al Abogado de Guardia',
              subtitle: lawyerName,
              phone: lawyerPhone,
              icon: Icons.gavel_rounded,
              iconColor: const Color(0xFF2E7D32),
              badge: caseItem.abogadoAsignado != null ? 'Asignado' : 'Guardia Cantón',
            ),

            const SizedBox(height: 12),

            // OPCIÓN 3: CENTRAL DE RADIO COOPERATIVA
            _callOptionTile(
              context: context,
              title: 'Central de Radio Cooperativa',
              subtitle: '${caseItem.cooperativa} • Despacho Operativo',
              phone: '+593 6 292 0100',
              icon: Icons.radio_rounded,
              iconColor: const Color(0xFFE65100),
              badge: 'Flota',
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _callOptionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String phone,
    required IconData icon,
    required Color iconColor,
    required String badge,
  }) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge,
                        style: ubuntuBold.copyWith(fontSize: 9, color: iconColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  phone,
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const Icon(Icons.call, size: 14, color: Colors.white),
            label: const Text('Llamar', style: TextStyle(fontSize: 12)),
            onPressed: () {
              Navigator.of(context).pop();
              Get.snackbar(
                '📞 Conectando Llamada...',
                'Marcando a $subtitle ($phone).',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF1B5E20),
                colorText: Colors.white,
                icon: const Icon(Icons.call, color: Colors.white),
                duration: const Duration(seconds: 4),
                margin: const EdgeInsets.all(16),
              );
            },
          ),
        ],
      ),
    );
  }
}
