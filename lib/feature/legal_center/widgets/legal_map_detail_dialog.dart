import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'legal_call_dialog.dart';
import 'legal_case_detail_dialog.dart';
import 'legal_dispatch_map.dart';

class LegalMapDetailDialog extends StatelessWidget {
  final LegalCase caseItem;

  const LegalMapDetailDialog({super.key, required this.caseItem});

  static void show(BuildContext context, LegalCase caseItem) {
    HapticFeedback.lightImpact();
    final controller = Get.find<LegalCenterController>();
    controller.selectCase(caseItem, moveMap: false);
    controller.focusCaseRoute(caseItem);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => LegalMapDetailDialog(caseItem: caseItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LegalCenterController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 700;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calcular altura adaptativa del mapa
    final double mapHeight = isMobile
        ? (screenHeight * 0.40).clamp(240.0, 360.0)
        : (screenHeight * 0.50).clamp(340.0, 480.0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 28,
        vertical: isMobile ? 16 : 24,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 860,
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.92,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CABECERA ELEGANTE (Idéntica a la vista de Expediente)
            _buildHeader(context, caseItem),

            // 2. CUERPO CON RESUMEN Y MAPA
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Resumen táctico del conductor y abogado asignado
                    _buildDispatchInfoBar(context, controller, caseItem, isDark, isMobile),

                    const SizedBox(height: 12),

                    // Contenedor del Mapa Táctico
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: mapHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: const LegalDispatchMap(
                          showFloatingIncidentCard: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. BARRA DE ACCIÓN INFERIOR
            _buildFooterActions(context, caseItem, isMobile),
          ],
        ),
      ),
    );
  }

  // --- CABECERA (IGUAL QUE EXPEDIENTE 360) ---
  Widget _buildHeader(BuildContext context, LegalCase c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: 0.45),
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
                    border: Border.all(
                      color: c.alertaNivel.color.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    c.alertaNivel.icon,
                    color: c.alertaNivel.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              c.id,
                              style: ubuntuBold.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: c.alertaNivel.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: c.alertaNivel.color.withValues(alpha: 0.7),
                              ),
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
                        'Despacho Táctico Georreferenciado • ${c.canton}, ${c.provincia}',
                        style: ubuntuRegular.copyWith(
                          fontSize: 11.5,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
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
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Cerrar mapa',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  // --- RESUMEN TÁCTICO SUPERIOR ---
  Widget _buildDispatchInfoBar(
    BuildContext context,
    LegalCenterController controller,
    LegalCase c,
    bool isDark,
    bool isMobile,
  ) {
    final assignedLawyer = controller.getAssignedLawyerForCase(c);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, size: 16, color: Color(0xFF2563EB)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${c.taxistaNombre} • Unidad #${c.unidad} (${c.cooperativa})',
                        style: ubuntuBold.copyWith(fontSize: 12.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: assignedLawyer != null
                      ? const Color(0xFF16A34A).withValues(alpha: 0.12)
                      : const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: assignedLawyer != null
                        ? const Color(0xFF16A34A).withValues(alpha: 0.4)
                        : const Color(0xFFD97706).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      assignedLawyer != null ? Icons.shield_rounded : Icons.search_rounded,
                      size: 13,
                      color: assignedLawyer != null
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      assignedLawyer != null
                          ? 'Abg. ${assignedLawyer.nombre}'
                          : (c.abogadoAsignado ?? 'Sin Abogado Asignado'),
                      style: ubuntuBold.copyWith(
                        fontSize: 11,
                        color: assignedLawyer != null
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  c.ubicacionDireccion,
                  style: ubuntuRegular.copyWith(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (c.distanciaAbogadoKm != null) ...[
                const SizedBox(width: 8),
                Text(
                  'Distancia: ${(c.distanciaAbogadoKm ?? 0).toStringAsFixed(1)} km',
                  style: ubuntuMedium.copyWith(
                    fontSize: 10.5,
                    color: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // --- BOTONES INFERIORES ---
  Widget _buildFooterActions(BuildContext context, LegalCase c, bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          // Botón Llamada Rápida
          Expanded(
            flex: isMobile ? 5 : 4,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF16A34A),
                side: const BorderSide(color: Color(0xFF16A34A)),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 14,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
              label: Text(
                isMobile ? 'Llamar' : 'Llamada Rápida',
                style: ubuntuBold.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                LegalCallDialog.show(context, c);
              },
            ),
          ),
          const SizedBox(width: 10),

          // Botón Ver Expediente 360°
          Expanded(
            flex: isMobile ? 5 : 4,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 14,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              icon: const Icon(Icons.folder_shared_rounded, size: 16, color: Colors.white),
              label: Text(
                isMobile ? 'Expediente' : 'Ver Expediente',
                style: ubuntuBold.copyWith(fontSize: 12, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                LegalCaseDetailDialog.show(context, c);
              },
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ],
      ),
    );
  }
}
