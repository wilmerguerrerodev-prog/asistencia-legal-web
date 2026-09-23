import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';

class LegalCasesTable extends StatelessWidget {
  const LegalCasesTable({super.key});

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
              // Barra superior de la tabla
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 460;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.emergency_share_rounded,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Casos y Siniestros en Vía',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ubuntuBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                    ),
                                    Text(
                                      'Seleccione un caso para desplegar el Expediente 360°',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).textTheme.bodySmall!.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // BOTÓN DE SIMULACIÓN PARA LA DEMO EN VIVO
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isCompact ? 10 : 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.add_alert_rounded, size: 16, color: Colors.white),
                          label: Text(
                            isCompact || isMobile ? '+ Simular' : '+ Simular Alerta',
                            style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),
                          ),
                          onPressed: () {
                            controller.simulateIncomingDriverAlert();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              // Contenido: Lista o Tabla
              if (cases.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Theme.of(context).hintColor),
                        const SizedBox(height: 10),
                        Text(
                          'No hay casos que coincidan con el filtro actual.',
                          style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isMobile)
                _buildMobileCardsList(context, controller, cases)
              else
                _buildDesktopTable(context, controller, cases),
            ],
          ),
        );
      },
    );
  }

  // --- VISTA MÓVIL: TARJETAS TOUCH-FRIENDLY ---
  Widget _buildMobileCardsList(
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
        final isSelected = controller.selectedCase?.id == c.id;

        return InkWell(
          onTap: () => controller.selectCase(c, isMobile: true),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.08)
                : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      c.id,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        // Urgencia
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: c.urgenciaColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: c.urgenciaColor),
                          ),
                          child: Text(
                            c.urgenciaLabel,
                            style: ubuntuBold.copyWith(
                              fontSize: 10,
                              color: c.urgenciaColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Estado
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: c.estadoColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            c.estadoLabel,
                            style: ubuntuBold.copyWith(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.blueGrey),
                    const SizedBox(width: 6),
                    Text(
                      c.taxistaNombre,
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        c.cooperativa,
                        style: ubuntuBold.copyWith(fontSize: 10, color: const Color(0xFFE65100)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${c.unidad} • ${c.placa}',
                      style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '• ${c.tipoIncidente}',
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reporte: ${c.horaReporte}',
                      style: ubuntuRegular.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Ver Expediente 360°',
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- VISTA ESCRITORIO: TABLA COMPLETA ---
  Widget _buildDesktopTable(
    BuildContext context,
    LegalCenterController controller,
    List<LegalCase> cases,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        headingRowColor: WidgetStateProperty.all(
          Theme.of(context).primaryColorLight.withValues(alpha: 0.6),
        ),
        headingTextStyle: ubuntuBold.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        dataRowMinHeight: 65,
        dataRowMaxHeight: 70,
        columns: const [
          DataColumn(label: Text('Código')),
          DataColumn(label: Text('Conductor & Flota')),
          DataColumn(label: Text('Cooperativa')),
          DataColumn(label: Text('Siniestro / Incidente')),
          DataColumn(label: Text('Nivel Urgencia')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Acción')),
        ],
        rows: cases.map((c) {
          final isSelected = controller.selectedCase?.id == c.id;

          return DataRow(
            selected: isSelected,
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (isSelected) {
                return Theme.of(context).primaryColor.withValues(alpha: 0.1);
              }
              return null;
            }),
            onSelectChanged: (_) => controller.selectCase(c),
            cells: [
              // Código
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.id,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      c.horaReporte,
                      style: ubuntuRegular.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Conductor
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.taxistaNombre,
                      style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    Text(
                      '${c.unidad} • Placa: ${c.placa}',
                      style: ubuntuRegular.copyWith(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ),
              ),

              // Cooperativa
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade600),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_taxi, size: 13, color: Color(0xFFE65100)),
                      const SizedBox(width: 4),
                      Text(
                        c.cooperativa,
                        style: ubuntuBold.copyWith(
                          fontSize: 11,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Siniestro
              DataCell(
                SizedBox(
                  width: 170,
                  child: Text(
                    c.tipoIncidente,
                    style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Urgencia
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.urgenciaColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.urgenciaColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: c.urgenciaColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        c.urgenciaLabel,
                        style: ubuntuBold.copyWith(
                          fontSize: 11,
                          color: c.urgenciaColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Estado
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.estadoColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    c.estadoLabel,
                    style: ubuntuBold.copyWith(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Acción
              DataCell(
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).dividerColor,
                    ),
                    backgroundColor: isSelected
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Ver 360°',
                    style: ubuntuBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => controller.selectCase(c),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
