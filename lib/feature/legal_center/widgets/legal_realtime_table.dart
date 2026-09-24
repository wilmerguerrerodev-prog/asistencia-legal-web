import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'legal_call_dialog.dart';
import 'legal_case_detail_dialog.dart';

class LegalRealtimeTable extends StatelessWidget {
  const LegalRealtimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        final cases = controller.filteredCases;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CABECERA SUPERIOR DE LA TABLA
              _buildTableHeader(context, controller, cases.length, isMobile),

              const Divider(height: 1),

              // CONTENIDO DE LA TABLA O MENSAJE VACÍO
              if (cases.isEmpty)
                _buildEmptyState(context, controller)
              else if (isMobile)
                _buildMobileIncidentStream(context, controller, cases)
              else
                _buildDesktopIncidentTable(context, controller, cases),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(
    BuildContext context,
    LegalCenterController controller,
    int count,
    bool isMobile,
  ) {
    if (isMobile) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00E676),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Incidentes en Vía',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count activos',
                          style: ubuntuBold.copyWith(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(Icons.add_alert_rounded, size: 13, color: Colors.white),
                  label: Text(
                    '+ Simular',
                    style: ubuntuBold.copyWith(fontSize: 10, color: Colors.white),
                  ),
                  onPressed: () {
                    controller.simulateIncomingDriverAlert();
                  },
                ),
              ],
            ),
            if (controller.activeKpiFilter != null) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => controller.toggleKpiFilter(controller.activeKpiFilter!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade700),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Filtro: ${controller.activeKpiFilter!.toUpperCase()}',
                        style: ubuntuBold.copyWith(fontSize: 10, color: const Color(0xFFE65100)),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.close, size: 10, color: Color(0xFFE65100)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Indicador de enlace en vivo
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF00E676),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Incidentes en Vía en Tiempo Real',
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count activos',
                  style: ubuntuBold.copyWith(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (controller.activeKpiFilter != null) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => controller.toggleKpiFilter(controller.activeKpiFilter!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade700),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filtro: ${controller.activeKpiFilter!.toUpperCase()}',
                          style: ubuntuBold.copyWith(fontSize: 10, color: const Color(0xFFE65100)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.close, size: 10, color: Color(0xFFE65100)),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          // BOTÓN DE SIMULACIÓN PARA DEMOS
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add_alert_rounded, size: 15, color: Colors.white),
            label: Text(
              '+ Simular Alerta SOS',
              style: ubuntuBold.copyWith(fontSize: 11, color: Colors.white),
            ),
            onPressed: () {
              controller.simulateIncomingDriverAlert();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, LegalCenterController controller) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.verified_rounded, size: 48, color: Colors.green.shade400),
            const SizedBox(height: 12),
            Text(
              'No hay incidentes pendientes en este territorio.',
              style: ubuntuBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pruebe cambiando la provincia/cantón o simule una nueva alerta.',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Limpiar Filtros'),
              onPressed: () => controller.resetFilters(),
            ),
          ],
        ),
      ),
    );
  }

  // --- TABLA COMPLETA PARA ESCRITORIO Y TABLET ---
  Widget _buildDesktopIncidentTable(
    BuildContext context,
    LegalCenterController controller,
    List<LegalCase> cases,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(
          Theme.of(context).primaryColorLight.withValues(alpha: 0.4),
        ),
        headingTextStyle: ubuntuBold.copyWith(
          fontSize: 11,
          color: Theme.of(context).textTheme.bodyLarge!.color,
          letterSpacing: 0.3,
        ),
        dataRowMinHeight: 70,
        dataRowMaxHeight: 75,
        horizontalMargin: 16,
        columnSpacing: 18,
        columns: const [
          DataColumn(label: Text('ALERTA')),
          DataColumn(label: Text('TIEMPO Y UBICACIÓN')),
          DataColumn(label: Text('CONDUCTOR / UNIDAD')),
          DataColumn(label: Text('DICTAMEN PRELIMINAR IA')),
          DataColumn(label: Text('ABOGADO ASIGNADO')),
          DataColumn(label: Text('ACCIONES')),
        ],
        rows: cases.map((c) {
          final isSelected = controller.selectedCase?.id == c.id;

          return DataRow(
            selected: isSelected,
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (isSelected) {
                return Theme.of(context).primaryColor.withValues(alpha: 0.05);
              }
              return null;
            }),
            onSelectChanged: (_) => controller.selectCase(c),
            cells: [
              // 1. COLUMNA ALERTA (Badge de color: Rojo, Amarillo, Azul)
              DataCell(_buildAlertBadge(c)),

              // 2. COLUMNA TIEMPO Y UBICACIÓN (ej. "Hace 5 min — Panamericana Norte, Otavalo")
              DataCell(_buildTimeAndLocationCell(context, c)),

              // 3. COLUMNA CONDUCTOR / UNIDAD (ej. "Carlos M. (Unidad 42 - Coop. Los Lagos)")
              DataCell(_buildDriverAndUnitCell(context, c)),

              // 4. COLUMNA DICTAMEN PRELIMINAR IA (1 sola línea sintética)
              DataCell(_buildIaDiagnosisCell(context, c)),

              // 5. COLUMNA ABOGADO ASIGNADO (Con selector para reasignar)
              DataCell(_buildLawyerAssignmentSelector(context, controller, c)),

              // 6. COLUMNA ACCIONES (Llamada rápida + Expediente)
              DataCell(_buildActionButtons(context, c)),
            ],
          );
        }).toList(),
      ),
    );
  }

  // --- COMPONENTES DE CELDAS ---

  // 1. Badge Alerta
  Widget _buildAlertBadge(LegalCase c) {
    final alert = c.alertaNivel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: alert.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: alert.color.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(alert.icon, size: 13, color: alert.color),
          const SizedBox(width: 4),
          Text(
            alert.label,
            style: ubuntuBold.copyWith(
              fontSize: 10,
              color: alert.color,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Tiempo y Ubicación
  Widget _buildTimeAndLocationCell(BuildContext context, LegalCase c) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 210),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 13, color: Color(0xFFD32F2F)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  c.ubicacionDireccion,
                  style: ubuntuBold.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 11, color: Theme.of(context).hintColor),
              const SizedBox(width: 4),
              Text(
                '${c.horaReporte} • ${c.canton}',
                style: ubuntuRegular.copyWith(
                  fontSize: 10,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. Conductor / Unidad
  Widget _buildDriverAndUnitCell(BuildContext context, LegalCase c) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 14, color: Colors.blueGrey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  c.taxistaNombre,
                  style: ubuntuBold.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Text(
                  '${c.unidad} • ${c.cooperativa}',
                  style: ubuntuBold.copyWith(
                    fontSize: 9,
                    color: const Color(0xFFE65100),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Dictamen Preliminar IA (1 sola línea con diagnóstico legal automático)
  Widget _buildIaDiagnosisCell(BuildContext context, LegalCase c) {
    return Container(
      width: 290,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF056AB4).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF056AB4).withValues(alpha: 0.2),
        ),
      ),
      child: Tooltip(
        message: c.dictamenIaRecomendacion,
        preferBelow: false,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 13, color: Color(0xFF056AB4)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                c.shortDictamenSummary,
                style: ubuntuMedium.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF0D47A1),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Abogado Asignado con selector para reasignar y badge de auto/manual
  Widget _buildLawyerAssignmentSelector(
    BuildContext context,
    LegalCenterController controller,
    LegalCase c,
  ) {
    final lawyers = controller.allLawyers
        .where((l) => l.estadoGuardia != LawyerGuardStatus.noAsociado)
        .toList();
    final isAssigned = c.abogadoAsignado != null;

    return PopupMenuButton<String>(
      tooltip: 'Cambiar o reasignar abogado (Control Operador)',
      onSelected: (newLawyer) {
        controller.overrideCaseLawyer(c.id, newLawyer, '12', reason: 'Reasignado manualmente por el Operador');
      },
      itemBuilder: (ctx) {
        return [
          const PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Reasignar Abogado en Territorio:',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ...lawyers.map((lawyer) {
            final isCurrent = c.abogadoAsignado == lawyer.nombre;
            final distKm = controller.calculateDistanceKm(c.lat, c.lng, lawyer.lat, lawyer.lng).toStringAsFixed(1);
            return PopupMenuItem<String>(
              value: lawyer.nombre,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: lawyer.estadoColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${lawyer.nombre} (${lawyer.canton})',
                          style: ubuntuRegular.copyWith(
                            fontSize: 11,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        Text(
                          'A $distKm km • ${lawyer.estadoLabel}',
                          style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrent)
                    const Icon(Icons.check, size: 14, color: Colors.green),
                ],
              ),
            );
          }),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isAssigned
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAssigned
                ? Theme.of(context).dividerColor
                : const Color(0xFFF57C00),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAssigned
                  ? (c.fueAsignadoAutomaticamente ? Icons.bolt_rounded : Icons.person_pin_rounded)
                  : Icons.person_add_alt_1_rounded,
              size: 14,
              color: isAssigned
                  ? (c.fueAsignadoAutomaticamente ? const Color(0xFF0D47A1) : Theme.of(context).primaryColor)
                  : const Color(0xFFE65100),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    c.abogadoAsignado ?? 'Sin asignar',
                    style: ubuntuBold.copyWith(
                      fontSize: 11,
                      color: isAssigned
                          ? Theme.of(context).textTheme.bodyLarge!.color
                          : const Color(0xFFE65100),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isAssigned) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: c.fueAsignadoAutomaticamente
                            ? const Color(0xFF0D47A1).withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        c.fueAsignadoAutomaticamente
                            ? (c.distanciaAbogadoKm != null ? '⚡ Auto (${c.distanciaAbogadoKm} km)' : '⚡ Auto GPS')
                            : '👤 Manual',
                        style: ubuntuBold.copyWith(
                          fontSize: 8.5,
                          color: c.fueAsignadoAutomaticamente
                              ? const Color(0xFF0D47A1)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 14,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }

  // 6. Botones de Acción (Llamada rápida + Expediente)
  Widget _buildActionButtons(BuildContext context, LegalCase c) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BOTÓN LLAMADA RÁPIDA
        IconButton(
          tooltip: 'Llamada Rápida Inmediata',
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: Color(0xFF2E7D32),
              size: 16,
            ),
          ),
          onPressed: () => LegalCallDialog.show(context, c),
        ),
        const SizedBox(width: 4),

        // BOTÓN EXPEDIENTE / DETALLES
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.folder_shared_outlined, size: 13, color: Colors.white),
          label: Text(
            'Expediente',
            style: ubuntuBold.copyWith(fontSize: 11, color: Colors.white),
          ),
          onPressed: () => LegalCaseDetailDialog.show(context, c),
        ),
      ],
    );
  }

  // --- VISTA RESPONSIVA MÓVIL EN TARJETAS LIMPIAS ---
  Widget _buildMobileIncidentStream(
    BuildContext context,
    LegalCenterController controller,
    List<LegalCase> cases,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cases.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final c = cases[index];

        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera: Alerta, ID y Tiempo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildAlertBadge(c),
                      const SizedBox(width: 8),
                      Text(
                        c.id,
                        style: ubuntuBold.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    c.horaReporte,
                    style: ubuntuRegular.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Ubicación y Conductor
              Row(
                children: [
                  const Icon(Icons.place_rounded, size: 13, color: Color(0xFFD32F2F)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${c.ubicacionDireccion} (${c.canton})',
                      style: ubuntuBold.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${c.taxistaNombre} • ${c.unidad} (${c.cooperativa})',
                      style: ubuntuRegular.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dictamen IA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF056AB4).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF056AB4)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        c.shortDictamenSummary,
                        style: ubuntuMedium.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF0D47A1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Selector de abogado y acciones
              Row(
                children: [
                  Expanded(
                    child: _buildLawyerAssignmentSelector(context, controller, c),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButtons(context, c),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
