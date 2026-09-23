import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';
import '../model/legal_case_model.dart';
import 'dispatch_lawyer_dialog.dart';

class Expediente360Panel extends StatelessWidget {
  final LegalCase caseItem;

  const Expediente360Panel({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CABECERA EXPEDIENTE 360
          _buildHeader(context, isMobile),

          const Divider(height: 1),

          // CUERPO SCROLLABLE DEL EXPEDIENTE
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BARRA DE ACCIÓN INMEDIATA (Botones Principales)
                _buildActionButtons(context, isMobile),

                const SizedBox(height: 16),

                // 2. FICHA DEL CONDUCTOR Y COOPERATIVA
                _buildDriverCard(context, isMobile),

                const SizedBox(height: 16),

                // 3. GEOLOCALIZACIÓN Y UBICACIÓN DEL SINIESTRO
                _buildLocationCard(context),

                const SizedBox(height: 16),

                // 4. PRE-DICTAMEN JURÍDICO IA & COIP
                _buildLegalAdvisoryCard(context),

                const SizedBox(height: 16),

                // 5. EVIDENCIAS Y RELATO
                _buildEvidenceAndStoryCard(context),

                const SizedBox(height: 16),

                // 6. LÍNEA DE TIEMPO / TRAZABILIDAD EN VIVO
                _buildTimelineCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CABECERA ---
  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: 0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusDefault),
          topRight: Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 480;

          final titleSection = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.folder_shared_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Expediente 360°',
                            overflow: TextOverflow.ellipsis,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          caseItem.id,
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Reportado: ${caseItem.horaReporte}',
                      overflow: TextOverflow.ellipsis,
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final badgesSection = Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: isNarrow ? WrapAlignment.start : WrapAlignment.end,
            children: [
              // Badge Urgencia Dinámico
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: caseItem.urgenciaColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: caseItem.urgenciaColor, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: caseItem.urgenciaColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      caseItem.urgenciaLabel,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: caseItem.urgenciaColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge Estado Dinámico (Cambia al Aprobar o Despachar)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: caseItem.estadoColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: caseItem.estadoColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      caseItem.estado == CaseStatus.dictamenAprobado
                          ? Icons.verified
                          : caseItem.estado == CaseStatus.abogadoDespachado
                              ? Icons.directions_car
                              : Icons.access_time_filled,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      caseItem.estadoLabel,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleSection,
                const SizedBox(height: 10),
                badgesSection,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleSection),
              const SizedBox(width: 8),
              badgesSection,
            ],
          );
        },
      ),
    );
  }

  // --- BOTONES DE ACCIÓN INMEDIATA (SOLICITUD CLAVE) ---
  Widget _buildActionButtons(BuildContext context, bool isMobile) {
    final controller = Get.find<LegalCenterController>();
    final isApproved = caseItem.estado == CaseStatus.dictamenAprobado;
    final isDispatched = caseItem.estado == CaseStatus.abogadoDespachado;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on_rounded, size: 18, color: Colors.amber.shade800),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Acciones Inmediatas del Abogado:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // BOTÓN 1: APROBAR DICTAMEN
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isApproved ? const Color(0xFF1B5E20) : const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    elevation: isApproved ? 0 : 3,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    isApproved ? Icons.check_circle : Icons.gavel_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isApproved ? 'Dictamen Aprobado ✓' : 'Aprobar Dictamen',
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  onPressed: () {
                    controller.approveDictamen(caseItem.id);
                  },
                ),
              ),
              const SizedBox(width: 10),

              // BOTÓN 2: DESPACHAR ABOGADO
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDispatched ? const Color(0xFF0D47A1) : const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    elevation: isDispatched ? 0 : 3,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    isDispatched ? Icons.check_circle : Icons.directions_car_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      isDispatched ? 'Abogado en Camino ✓' : 'Despachar Abogado',
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  onPressed: () {
                    Get.dialog(DispatchLawyerDialog(caseItem: caseItem));
                  },
                ),
              ),
            ],
          ),
          if (isDispatched && caseItem.abogadoAsignado != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 15, color: Color(0xFF1565C0)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Asignado a: ${caseItem.abogadoAsignado!} • ${caseItem.horaDespacho ?? "En camino"}',
                      style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- FICHA DEL CONDUCTOR Y COOPERATIVA ---
  Widget _buildDriverCard(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                      radius: 20,
                      child: Icon(Icons.person, color: Theme.of(context).primaryColor, size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseItem.taxistaNombre,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          Text(
                            'C.I.: ${caseItem.taxistaCedula}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).textTheme.bodySmall!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Badge de la Cooperativa
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_taxi, size: 14, color: Color(0xFFE65100)),
                    const SizedBox(width: 4),
                    Text(
                      caseItem.cooperativa,
                      style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Cuadrícula de datos del vehículo (Responsiva para evitar overflow)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 480;
                if (isCompact) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(context, 'Unidad', caseItem.unidad, Icons.tag),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoItem(context, 'Placa', caseItem.placa, Icons.pin),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(context, 'Vehículo', caseItem.vehiculoModelo, Icons.directions_car),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoItem(context, 'Seguro', caseItem.estadoSeguro, Icons.shield),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildInfoItem(context, 'Unidad', caseItem.unidad, Icons.tag),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: _buildInfoItem(context, 'Placa', caseItem.placa, Icons.pin),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: _buildInfoItem(context, 'Vehículo', caseItem.vehiculoModelo, Icons.directions_car),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _buildInfoItem(context, 'Seguro', caseItem.estadoSeguro, Icons.shield),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone_in_talk, size: 14, color: Colors.green),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Teléfono directo: ${caseItem.taxistaTelefono}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.call, size: 16, color: Colors.green),
                label: Text(
                  'Llamar',
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green),
                ),
                onPressed: () {
                  Get.snackbar(
                    '📞 Llamada Iniciada',
                    'Conectando en línea directa con ${caseItem.taxistaNombre} (${caseItem.taxistaTelefono})...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Theme.of(context).primaryColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ubuntuRegular.copyWith(
                  fontSize: 10,
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: ubuntuBold.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ],
    );
  }

  // --- GEOLOCALIZACIÓN Y UBICACIÓN ---
  Widget _buildLocationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Geolocalización en Tiempo Real del Siniestro',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            caseItem.ubicacionDireccion,
            style: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 8),

          // Contenedor visual de mapa simulado
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFCFD8DC),
                  Color(0xFFECEFF1),
                  Color(0xFFB0BEC5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Stack(
              children: [
                // Calles dibujadas de fondo
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Container(height: 12, color: Colors.white.withValues(alpha: 0.7)),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 80,
                  child: Container(width: 14, color: Colors.white.withValues(alpha: 0.7)),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 120,
                  child: Container(width: 18, color: Colors.amber.shade200.withValues(alpha: 0.8)),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.local_taxi, color: Colors.white, size: 18),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${caseItem.cooperativa} • ${caseItem.unidad}',
                          style: ubuntuBold.copyWith(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'GPS: ${caseItem.lat.toStringAsFixed(4)}, ${caseItem.lng.toStringAsFixed(4)}',
                      style: ubuntuRegular.copyWith(fontSize: 9, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PRE-DICTAMEN JURÍDICO IA & COIP ---
  Widget _buildLegalAdvisoryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF1565C0), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pre-Dictamen Jurídico Automatizado (LegalTech IA)',
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'COIP Ecuador',
                  style: ubuntuBold.copyWith(fontSize: 10, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFBBDEFB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.balance, size: 16, color: Color(0xFF1565C0)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    caseItem.articuloCoip,
                    style: ubuntuBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Recomendación Estratégica para el Abogado:',
            style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall,
              color: const Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caseItem.dictamenIaRecomendacion,
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: const Color(0xFF263238),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- EVIDENCIAS Y RELATO ---
  Widget _buildEvidenceAndStoryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.record_voice_over_rounded, size: 18, color: Colors.purple),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Declaración y Relato Fáctico del Taxista',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              '"${caseItem.relatoConductor}"',
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                fontStyle: FontStyle.italic,
                height: 1.4,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Evidencias Adjuntas al Expediente:',
            style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: caseItem.evidencias.map((ev) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(ev.icon, size: 18, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ev.title,
                          style: ubuntuMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        Text(
                          ev.detail,
                          style: ubuntuRegular.copyWith(
                            fontSize: 9,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- LÍNEA DE TIEMPO / TRAZABILIDAD EN VIVO ---
  Widget _buildTimelineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Trazabilidad en Vivo del Caso',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...caseItem.timeline.map((event) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: event.color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(event.icon, size: 14, color: event.color),
                      ),
                      Container(
                        width: 2,
                        height: 20,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ubuntuBold.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              event.time,
                              style: ubuntuMedium.copyWith(
                                fontSize: 10,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          event.description,
                          style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).textTheme.bodySmall!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
