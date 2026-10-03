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
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    Text(
                                      'Seleccione un caso para desplegar el Expediente 360°',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ubuntuRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                          style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
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
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Badge Categoría Oficial
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: c.tipoAlerta.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: c.tipoAlerta.color.withValues(alpha: 0.6)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(c.tipoAlerta.icon, size: 11, color: c.tipoAlerta.color),
                              const SizedBox(width: 4),
                              Text(
                                c.tipoAlerta.label,
                                style: ubuntuBold.copyWith(
                                  fontSize: 9.5,
                                  color: c.tipoAlerta.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Estado
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: c.estadoColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            c.estadoLabel,
                            style: ubuntuBold.copyWith(
                              fontSize: 9.5,
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
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '• ${c.tipoIncidente}',
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Badge de Estatus de Membresía / Prueba Gratuita
                Row(
                  children: [
                    if (c.esPruebaGratuita)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF2563EB)),
                        ),
                        child: Text(
                          '🎁 Prueba Gratuita: ${c.consultasGratuitasRestantes}/${c.consultasGratuitasTotales} restantes',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                        ),
                      )
                    else if (c.esPlanVip || c.suscripcionActiva)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF16A34A)),
                        ),
                        child: const Text(
                          '⭐ Plan VIP 24/7',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                        ),
                      ),
                  ],
                ),
                // Tarjeta destacada de "Otro problema" si aplica
                if (c.isOtroProblema) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.gavel_rounded, size: 12, color: Color(0xFF7C3AED)),
                            SizedBox(width: 4),
                            Text(
                              'Detalle "Otro Problema" (Consulta Legal):',
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF6D28D9)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.descripcionDetalladaCliente,
                          style: ubuntuRegular.copyWith(fontSize: 10, color: const Color(0xFF4C1D95)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
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
          color: Theme.of(context).textTheme.bodyLarge?.color,
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
                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    if (c.esPruebaGratuita)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF2563EB)),
                        ),
                        child: Text(
                          '🎁 Prueba (${c.consultasGratuitasRestantes}/${c.consultasGratuitasTotales})',
                          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                        ),
                      )
                    else if (c.esPlanVip || c.suscripcionActiva)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFF16A34A)),
                        ),
                        child: const Text(
                          '⭐ VIP 24/7',
                          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
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

              // Siniestro y Categoría
              DataCell(
                SizedBox(
                  width: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.tipoAlerta.backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: c.tipoAlerta.color.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(c.tipoAlerta.icon, size: 11, color: c.tipoAlerta.color),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                c.tipoAlerta.label,
                                style: ubuntuBold.copyWith(fontSize: 9.5, color: c.tipoAlerta.color),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        c.tipoIncidente,
                        style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
