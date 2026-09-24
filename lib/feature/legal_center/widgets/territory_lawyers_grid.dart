import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'legal_escalation_dialog.dart';

class TerritoryLawyersGrid extends StatelessWidget {
  const TerritoryLawyersGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        final lawyers = controller.territoryLawyers;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE RESUMEN DE GUARDIA
            _buildSupervisionHeader(context, controller, lawyers.length, isMobile),

            const SizedBox(height: 14),

            // CUADRÍCULA DE TARJETAS DE ABOGADOS
            if (lawyers.isEmpty)
              _buildEmptyLawyers(context, controller)
            else
              _buildLawyersCards(context, controller, lawyers, isMobile),
          ],
        );
      },
    );
  }

  Widget _buildSupervisionHeader(
    BuildContext context,
    LegalCenterController controller,
    int count,
    bool isMobile,
  ) {
    final onLineCount =
        controller.territoryLawyers.where((l) => l.estadoGuardia == LawyerGuardStatus.enLinea).length;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
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
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isMobile ? 'Supervisión por Cantón' : 'Supervisión de Abogados de Territorio por Cantón',
                        style: ubuntuBold.copyWith(
                          fontSize: isMobile ? Dimensions.fontSizeSmall : Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${controller.selectedProvince} • Cantón: ${controller.selectedCanton}',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).hintColor,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2E7D32)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$onLineCount / $count en línea',
                  style: ubuntuBold.copyWith(
                    fontSize: 11,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLawyers(BuildContext context, LegalCenterController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.person_off_rounded, size: 48, color: Theme.of(context).hintColor),
            const SizedBox(height: 12),
            Text(
              'No se encontraron abogados asignados en este cantón.',
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(height: 4),
            Text(
              'Seleccione "Todos" los cantones para supervisar la provincia completa.',
              style: ubuntuRegular.copyWith(fontSize: 12, color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLawyersCards(
    BuildContext context,
    LegalCenterController controller,
    List<TerritoryLawyer> lawyers,
    bool isMobile,
  ) {
    final crossAxisCount = isMobile ? 1 : (MediaQuery.of(context).size.width < 1100 ? 2 : 3);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: lawyers.map((lawyer) {
            final cardWidth = crossAxisCount == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - (14 * (crossAxisCount - 1))) / crossAxisCount;

            return SizedBox(
              width: cardWidth,
              child: _buildLawyerCard(context, controller, lawyer),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLawyerCard(
    BuildContext context,
    LegalCenterController controller,
    TerritoryLawyer lawyer,
  ) {
    final activeCasesCount = controller.allCases
        .where((c) =>
            c.abogadoAsignado == lawyer.nombre &&
            c.estado != CaseStatus.atendido)
        .length;

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CABECERA: NOMBRE, CANTÓN ASIGNADO Y AVATAR
          Row(
            children: [
              // Avatar con iniciales
              CircleAvatar(
                radius: 20,
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Text(
                  _getInitials(lawyer.nombre),
                  style: ubuntuBold.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.nombre,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Cantón asignado
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 12, color: Color(0xFFD32F2F)),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '${lawyer.canton} (${lawyer.provincia})',
                            style: ubuntuMedium.copyWith(
                              fontSize: 11,
                              color: Theme.of(context).primaryColor,
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
              // Selector interactivo de Estado de Guardia
              _buildStatusSelector(context, controller, lawyer),
            ],
          ),

          const SizedBox(height: 10),

          // 2. UNIDAD MÓVIL Y TELÉFONO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car_filled_outlined, size: 14, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lawyer.unidadMovil,
                          style: ubuntuRegular.copyWith(
                            fontSize: 10,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  lawyer.telefono,
                  style: ubuntuBold.copyWith(fontSize: 10, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. MÉTRICA DE CUMPLIMIENTO: CASOS RECIBIDOS VS ATENDIDOS A TIEMPO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cumplimiento SLA a Tiempo:',
                    style: ubuntuRegular.copyWith(
                      fontSize: 11,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  Text(
                    '${lawyer.casosAtendidosATiempo} / ${lawyer.casosRecibidos} atendidos (${lawyer.porcentajeCumplimiento}%)',
                    style: ubuntuBold.copyWith(
                      fontSize: 11,
                      color: lawyer.porcentajeCumplimiento >= 80
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFF57C00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Barra visual de porcentaje
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: lawyer.casosRecibidos == 0
                      ? 1.0
                      : lawyer.casosAtendidosATiempo / lawyer.casosRecibidos,
                  minHeight: 6,
                  backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    lawyer.porcentajeCumplimiento >= 80
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFF57C00),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ETA prom. arribo: ${lawyer.tiempoPromedioRespuestaMin} min',
                    style: ubuntuRegular.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  Text(
                    activeCasesCount > 0
                        ? '$activeCasesCount caso(s) en curso'
                        : 'Sin casos activos',
                    style: ubuntuBold.copyWith(
                      fontSize: 10,
                      color: activeCasesCount > 0
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 4. BOTÓN DE ESCALAMIENTO / REMISIÓN DIRECTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: lawyer.estadoGuardia == LawyerGuardStatus.noAsociado
                    ? (activeCasesCount > 0 ? const Color(0xFFE65100) : const Color(0xFF90A4AE))
                    : const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                lawyer.estadoGuardia == LawyerGuardStatus.noAsociado
                    ? (activeCasesCount > 0 ? Icons.sync_alt_rounded : Icons.person_off_rounded)
                    : Icons.flash_on_rounded,
                size: 15,
                color: Colors.white,
              ),
              label: Text(
                lawyer.estadoGuardia == LawyerGuardStatus.noAsociado
                    ? (activeCasesCount > 0 ? 'Remitir Casos Pendientes ($activeCasesCount)' : 'Abogado No Asociado')
                    : 'Escalamiento Directo',
                style: ubuntuBold.copyWith(fontSize: 11, color: Colors.white),
              ),
              onPressed: () {
                LegalEscalationDialog.show(
                  context,
                  lawyer,
                  initialReason: lawyer.estadoGuardia == LawyerGuardStatus.noAsociado
                      ? 'El abogado ya no se encuentra asociado a la red'
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector(
    BuildContext context,
    LegalCenterController controller,
    TerritoryLawyer lawyer,
  ) {
    final activeCasesCount = controller.allCases
        .where((c) =>
            c.abogadoAsignado == lawyer.nombre &&
            c.estado != CaseStatus.atendido)
        .length;

    return PopupMenuButton<LawyerGuardStatus>(
      tooltip: 'Cambiar estado de guardia',
      onSelected: (newStatus) {
        if (newStatus == LawyerGuardStatus.noAsociado && activeCasesCount > 0) {
          // Si tiene casos activos, solicitar la remisión obligatoria de los casos
          LegalEscalationDialog.show(
            context,
            lawyer,
            initialReason: 'El abogado ya no se encuentra asociado a la red',
          );
        } else {
          controller.updateLawyerStatus(lawyer.id, newStatus);
        }
      },
      itemBuilder: (ctx) {
        return [
          _statusMenuItem(LawyerGuardStatus.enLinea, 'En línea', const Color(0xFF2E7D32)),
          _statusMenuItem(LawyerGuardStatus.enAudiencia, 'En audiencia', const Color(0xFFF57C00)),
          _statusMenuItem(LawyerGuardStatus.noDisponible, 'No disponible', const Color(0xFFD32F2F)),
          _statusMenuItem(LawyerGuardStatus.noAsociado, 'Ya no asociado', const Color(0xFF546E7A)),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: lawyer.estadoBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: lawyer.estadoColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: lawyer.estadoColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              lawyer.estadoLabel,
              style: ubuntuBold.copyWith(
                fontSize: 10,
                color: lawyer.estadoColor,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 12, color: lawyer.estadoColor),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<LawyerGuardStatus> _statusMenuItem(
    LawyerGuardStatus status,
    String label,
    Color color,
  ) {
    return PopupMenuItem<LawyerGuardStatus>(
      value: status,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: ubuntuMedium.copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.replaceAll('Dr. ', '').replaceAll('Dra. ', '').replaceAll('Abg. ', '').split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return 'AB';
  }
}
