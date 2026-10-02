import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/main_page_layout.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/utils/dimensions.dart';

class SuscripcionConductorScreen extends StatelessWidget {
  const SuscripcionConductorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConductorController controller = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return MainPageLayout(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 14 : Dimensions.paddingSizeExtraLarge,
          horizontal: isMobile ? 14 : Dimensions.paddingSizeExtraLarge,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Barra de Navegación Superior / Volver
                Row(
                  children: [
                    InkWell(
                      key: const Key('btn_volver_desde_suscripcion'),
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(RouteHelper.getSosConductorRoute());
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mi Suscripción",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Estado de tu membresía legal y cobertura activa",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 2. Tarjeta Principal de Membresía Digital
                Obx(() {
                  final bool estaActiva = controller.estaSuscripcionActiva.value;
                  final String estadoTexto = controller.estadoSuscripcion.value;
                  final String planTexto = controller.planSuscripcion.value;
                  final String ultimoPago = controller.fechaUltimoPago.value;
                  final String fechaCorte = controller.fechaVencimiento.value;
                  final int diasRestantes = controller.diasRestantesSuscripcion.value;

                  return Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: estaActiva
                            ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE))
                            : Colors.redAccent.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (estaActiva ? const Color(0xFF2563EB) : Colors.redAccent)
                              .withValues(alpha: isDark ? 0.2 : 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cabecera de la Tarjeta con Insignia y Estado
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: estaActiva
                                ? (isDark ? const Color(0xFF0F172A) : const Color(0xFFEFF6FF))
                                : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2)),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow = constraints.maxWidth < 440;

                              final headerLeft = Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: estaActiva ? const Color(0xFF2563EB) : Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.shield_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "MEMBRESÍA LEGALTECH",
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.8,
                                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "Defensa Jurídica para Conductor",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );

                              final chipEstado = Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: estaActiva
                                      ? const Color(0xFF10B981).withValues(alpha: 0.15)
                                      : Colors.redAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: estaActiva
                                        ? const Color(0xFF10B981).withValues(alpha: 0.5)
                                        : Colors.redAccent.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      estaActiva
                                          ? Icons.check_circle_rounded
                                          : Icons.warning_amber_rounded,
                                      size: 14,
                                      color: estaActiva
                                          ? const Color(0xFF10B981)
                                          : Colors.redAccent,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      estadoTexto,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: estaActiva
                                            ? const Color(0xFF10B981)
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (isNarrow) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    headerLeft,
                                    const SizedBox(height: 10),
                                    chipEstado,
                                  ],
                                );
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: headerLeft),
                                  const SizedBox(width: 8),
                                  chipEstado,
                                ],
                              );
                            },
                          ),
                        ),

                        // Cuerpo con los datos exactos solicitados
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. PLAN ACTUAL
                              _buildInfoItem(
                                isDark: isDark,
                                icono: Icons.workspace_premium_rounded,
                                colorIcono: const Color(0xFF2563EB),
                                etiqueta: "PLAN ACTUAL DE COBERTURA",
                                valor: planTexto,
                              ),

                              const SizedBox(height: 16),
                              Divider(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                height: 1,
                              ),
                              const SizedBox(height: 16),

                              // 2. ÚLTIMO PAGO REALIZADO
                              _buildInfoItem(
                                isDark: isDark,
                                icono: Icons.calendar_today_rounded,
                                colorIcono: const Color(0xFF10B981),
                                etiqueta: "ÚLTIMO PAGO REALIZADO",
                                valor: ultimoPago,
                              ),

                              const SizedBox(height: 16),
                              Divider(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                height: 1,
                              ),
                              const SizedBox(height: 16),

                              // 3. FECHA DE VENCIMIENTO Y PRÓXIMO CORTE
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.event_repeat_rounded,
                                      size: 20,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "PRÓXIMO CORTE / FECHA DE VENCIMIENTO",
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          fechaCorte,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: FittedBox(
                                             fit: BoxFit.scaleDown,
                                             alignment: Alignment.centerLeft,
                                             child: Text(
                                               "Te quedan $diasRestantes días de cobertura activa",
                                               style: const TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2563EB),
                                             ),
                                           ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // 4. FICHA RESUMEN DEL TITULAR AFILIADO
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
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
                                        const Icon(
                                          Icons.badge_rounded,
                                          size: 16,
                                          color: Color(0xFF2563EB),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "DATOS DEL AFILIADO",
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${controller.nombreConductor} · ${controller.unidadTaxi}",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "Cooperativa: ${controller.cooperativa} • Cédula: ${controller.cedulaConductor}",
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 11,
                                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
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
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required bool isDark,
    required IconData icono,
    required Color colorIcono,
    required String etiqueta,
    required String valor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorIcono.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icono,
            size: 20,
            color: colorIcono,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
