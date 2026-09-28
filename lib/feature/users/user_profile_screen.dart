import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _picker = ImagePicker();

  void _abrirModalCambiarFoto(BuildContext context, ConductorController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Actualizar Foto de Perfil",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Selecciona una foto clara para tu credencial oficial",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF2563EB)),
                  ),
                  title: const Text("Tomar foto / Selfie", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Usar la cámara del teléfono"),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final XFile? photo = await _picker.pickImage(
                        source: ImageSource.camera,
                        preferredCameraDevice: CameraDevice.front,
                      );
                      if (photo != null) {
                        controller.actualizarDatosConductor(
                          nombre: controller.nombreConductor,
                          unidad: controller.unidadTaxi,
                          cooperativaNombre: controller.cooperativa,
                          placa: controller.placaVehiculo,
                          foto: photo.path,
                        );
                        Get.snackbar(
                          "Foto actualizada",
                          "Nueva foto de perfil establecida correctamente.",
                          backgroundColor: const Color(0xFF16A34A),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                        );
                      }
                    } catch (e) {
                      debugPrint("Error al abrir cámara: $e");
                    }
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library_rounded, color: Color(0xFF10B981)),
                  ),
                  title: const Text("Seleccionar de la galería", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Elegir una imagen de tu dispositivo"),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    try {
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        controller.actualizarDatosConductor(
                          nombre: controller.nombreConductor,
                          unidad: controller.unidadTaxi,
                          cooperativaNombre: controller.cooperativa,
                          placa: controller.placaVehiculo,
                          foto: image.path,
                        );
                        Get.snackbar(
                          "Foto actualizada",
                          "Nueva foto de perfil guardada con éxito.",
                          backgroundColor: const Color(0xFF16A34A),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                        );
                      }
                    } catch (e) {
                      debugPrint("Error al abrir galería: $e");
                    }
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ConductorController controller = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isMobile ? const MenuDrawer() : null,
      body: SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context)) const MenuDrawer(),
            Expanded(
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 12 : Dimensions.paddingSizeLarge,
                        horizontal: isMobile ? 12 : Dimensions.paddingSizeLarge,
                      ),
                      child: Obx(() {
                        final esConductor = controller.rolActivo.value == 'conductor';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Selector rápido de vista (Conductor / Abogado)
                            _buildRoleSelector(context, controller, isDark),
                            const SizedBox(height: 16),

                            // 2. Cabecera principal de Perfil
                            esConductor
                                ? _buildConductorHeader(context, controller, isDark)
                                : _buildAbogadoHeader(context, controller, isDark),
                            const SizedBox(height: 18),

                            // 3. Tarjetas detalladas de datos
                            esConductor
                                ? _buildConductorDetails(context, controller, isDark)
                                : _buildAbogadoDetails(context, controller, isDark),
                            const SizedBox(height: 24),

                            // 4. Botones de acción rápida
                            _buildActionButtons(context, controller, esConductor, isDark),
                            Center(
                              child: Text(
                                "LegalTech Ecuador © 2026 · Asistencia Legal Vial 24/7",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Selector para alternar entre el Perfil de Conductor y el Perfil de Abogado
  Widget _buildRoleSelector(BuildContext context, ConductorController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.cambiarRol('conductor'),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: controller.rolActivo.value == 'conductor'
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: controller.rolActivo.value == 'conductor'
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_taxi_rounded,
                      size: 18,
                      color: controller.rolActivo.value == 'conductor'
                          ? Colors.white
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Perfil Conductor",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: controller.rolActivo.value == 'conductor'
                              ? Colors.white
                              : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => controller.cambiarRol('abogado'),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: controller.rolActivo.value == 'abogado'
                      ? const Color(0xFF0F766E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: controller.rolActivo.value == 'abogado'
                      ? [
                          BoxShadow(
                            color: const Color(0xFF0F766E).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gavel_rounded,
                      size: 18,
                      color: controller.rolActivo.value == 'abogado'
                          ? Colors.white
                          : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Perfil Abogado",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: controller.rolActivo.value == 'abogado'
                              ? Colors.white
                              : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Cabecera con foto y datos principales del Conductor
  Widget _buildConductorHeader(BuildContext context, ConductorController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2563EB), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildAvatarImage(controller.fotoConductor),
                ),
              ),
              InkWell(
                onTap: () => _abrirModalCambiarFoto(context, controller),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            controller.nombreConductor,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF16A34A).withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Conductor Verificado",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Cédula: ${controller.cedulaConductor} · ${controller.cooperativa}",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Cabecera con foto y acreditación del Abogado
  Widget _buildAbogadoHeader(BuildContext context, ConductorController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0F766E), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const ClipOval(
              child: Icon(Icons.person_outline_rounded, size: 52, color: Color(0xFF0F766E)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.abogadoZona.nombre,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0F766E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF0F766E).withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF0F766E)),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    "Abogado Acreditado",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F766E),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Matrícula: ${controller.abogadoZona.matricula}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.abogadoZona.entidadAcreditadora,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Detalles completos del Conductor (ANT, Taxi, Cobertura 24/7)
  Widget _buildConductorDetails(BuildContext context, ConductorController controller, bool isDark) {
    return Column(
      children: [
        // Tarjeta ANT Ecuador
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.badge_outlined,
          iconColor: const Color(0xFF2563EB),
          title: "Credenciales de Tránsito (ANT Ecuador)",
          subtitle: "Datos consultados y validados en el registro oficial",
          rows: [
            _buildDataRow("Tipo de Licencia", controller.tipoLicencia, isDark, highlight: true),
            _buildDataRow("Puntos de Licencia", "30 / 30 Puntos (Íntegros)", isDark, success: true),
            _buildDataRow("Estado Habilitante", "Vigente y Autorizado", isDark, success: true),
            _buildDataRow("Cédula Registrada", controller.cedulaConductor, isDark),
          ],
        ),
        const SizedBox(height: 16),

        // Tarjeta Vehículo y Cooperativa
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.local_taxi_rounded,
          iconColor: const Color(0xFFF59E0B),
          title: "Vehículo y Cooperativa",
          subtitle: "Unidad comercial asignada a la red de protección",
          rows: [
            _buildDataRow("Cooperativa", controller.cooperativa, isDark),
            _buildDataRow("Unidad de Taxi", controller.unidadTaxi, isDark, highlight: true),
            _buildDataRow("Placa del Vehículo", controller.placaVehiculo, isDark, highlight: true),
            _buildDataRow("Teléfono / WhatsApp", controller.telefonoConductor, isDark),
          ],
        ),
        const SizedBox(height: 16),

        // Tarjeta Cobertura LegalTech
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.shield_rounded,
          iconColor: const Color(0xFF10B981),
          title: "Protección Vial LegalTech 24/7",
          subtitle: "Cobertura jurídica activa e inmediata ante siniestros",
          rows: [
            _buildDataRow("Estado del Servicio", "Activo 24 Horas al Día", isDark, success: true),
            _buildDataRow("Abogado en Territorio", controller.abogadoActivo.nombre, isDark),
            _buildDataRow("Línea de Urgencias", controller.abogadoActivo.telefono, isDark, highlight: true),
            _buildDataRow("Cobertura", "Choques, Peritajes, Retenciones y COIP", isDark),
          ],
        ),
      ],
    );
  }

  /// Detalles completos del Abogado (Judicatura, Guardia, Métricas)
  Widget _buildAbogadoDetails(BuildContext context, ConductorController controller, bool isDark) {
    return Column(
      children: [
        // Estado de Guardia Activa
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: controller.abogadoDisponibleGuardia.value
                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                : Colors.orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.abogadoDisponibleGuardia.value
                  ? const Color(0xFF10B981).withValues(alpha: 0.35)
                  : Colors.orange.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      controller.abogadoDisponibleGuardia.value
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: controller.abogadoDisponibleGuardia.value
                          ? const Color(0xFF10B981)
                          : Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.abogadoDisponibleGuardia.value
                                ? "En Guardia Activa (Disponible)"
                                : "Fuera de Guardia (No disponible)",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: controller.abogadoDisponibleGuardia.value
                                  ? const Color(0xFF10B981)
                                  : Colors.orange,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.abogadoDisponibleGuardia.value
                                ? "Recibirá llamadas inmediatas de conductores con SOS"
                                : "Las alertas se derivarán a los otros abogados de turno",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: controller.abogadoDisponibleGuardia.value,
                activeThumbColor: const Color(0xFF10B981),
                onChanged: (val) => controller.toggleGuardiaAbogado(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tarjeta Acreditación Judicial
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFF0F766E),
          title: "Acreditación y Títulos Profesionales",
          subtitle: "Registro oficial del Consejo de la Judicatura del Ecuador",
          rows: [
            _buildDataRow("Matrícula Foro", controller.abogadoZona.matricula, isDark, highlight: true),
            _buildDataRow("Ente Rector", controller.abogadoZona.entidadAcreditadora, isDark),
            _buildDataRow("Título de Grado", controller.abogadoZona.tituloGrado, isDark),
            _buildDataRow("Alma Máter", controller.abogadoZona.universidad, isDark),
            _buildDataRow("Especialidad", controller.abogadoZona.especialidadPosgrado, isDark),
            _buildDataRow("Maestría", controller.abogadoZona.maestria, isDark),
          ],
        ),
        const SizedBox(height: 16),

        // Tarjeta Despacho y Cobertura
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFF3B82F6),
          title: "Despacho y Cobertura Territorial",
          subtitle: "Jurisdicción asignada para asistencia presencial",
          rows: [
            _buildDataRow("Despacho", controller.abogadoZona.despacho, isDark),
            _buildDataRow("Zona de Acción", controller.abogadoZona.zonaODistancia, isDark, highlight: true),
            _buildDataRow("WhatsApp de Guardia", controller.abogadoZona.telefono, isDark, highlight: true),
            _buildDataRow("Experiencia", controller.abogadoZona.experiencia, isDark),
            _buildDataRow("Casos Resueltos", controller.abogadoZona.casosAtendidos, isDark, success: true),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Widget> rows,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, bool isDark, {bool highlight = false, bool success = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: highlight || success ? FontWeight.w700 : FontWeight.w500,
                color: success
                    ? const Color(0xFF16A34A)
                    : (highlight
                        ? const Color(0xFF2563EB)
                        : (isDark ? Colors.white : const Color(0xFF0F172A))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ConductorController controller, bool esConductor, bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () {
              if (esConductor) {
                Get.toNamed(RouteHelper.initial);
              } else {
                Get.toNamed(RouteHelper.getEdutechRoute());
              }
            },
            icon: Icon(
              esConductor ? Icons.warning_amber_rounded : Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              esConductor ? "Ir al Botón SOS Vial" : "Ir al Panel de Casos",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: esConductor ? const Color(0xFFDC2626) : const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () {
              Get.offAllNamed(RouteHelper.loginScreen);
            },
            icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
            label: const Text(
              "Cerrar Sesión",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.redAccent),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage(String fotoPath) {
    if (fotoPath.startsWith("http")) {
      return Image.network(
        fotoPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 48, color: Color(0xFF2563EB)),
      );
    }
    if (!kIsWeb && File(fotoPath).existsSync()) {
      return Image.file(
        File(fotoPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, size: 48, color: Color(0xFF2563EB)),
      );
    }
    return Image.asset(
      fotoPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.person, size: 48, color: Color(0xFF2563EB)),
    );
  }
}