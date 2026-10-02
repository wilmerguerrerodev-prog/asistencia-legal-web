import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/main_page_layout.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/core/services/firebase_service.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthMockController>()) {
      final auth = Get.find<AuthMockController>();
      final conductorController = Get.isRegistered<ConductorController>()
          ? Get.find<ConductorController>()
          : Get.put(ConductorController());
      if (auth.isAssociateLawyer || auth.isAdminLawyer || auth.isItAdmin) {
        conductorController.cambiarRol('abogado');
      } else {
        conductorController.cambiarRol('conductor');
      }
    }
  }

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

  void _mostrarDialogoConfirmarCerrarSesion(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "¿Cerrar Sesión?",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "¿Estás seguro de que deseas salir de tu cuenta? Tendrás que ingresar tus credenciales nuevamente.",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          FirebaseService().signOut();
                          Get.offAllNamed(RouteHelper.loginScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sí, Salir",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final ConductorController controller = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return MainPageLayout(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? 12 : Dimensions.paddingSizeLarge,
          horizontal: isMobile ? 12 : Dimensions.paddingSizeLarge,
        ),
        child: Obx(() {
          final auth = Get.isRegistered<AuthMockController>()
              ? Get.find<AuthMockController>()
              : null;
          final esConductor = auth != null
              ? auth.isClientDriver
              : (controller.rolActivo.value == 'conductor');
          final showRoleSelector = auth == null || auth.isItAdmin;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Selector rápido de vista (Conductor / Abogado) - sólo visible para SuperAdmin TI o tests
              if (showRoleSelector) ...[
                _buildRoleSelector(context, controller, isDark),
                const SizedBox(height: 16),
              ],

              // 2. Cabecera principal de Perfil
              esConductor
                  ? _buildConductorHeader(context, controller, isDark)
                  : _buildAbogadoHeader(context, controller, isDark, auth),
              const SizedBox(height: 18),

              // 3. Tarjetas detalladas de datos
              esConductor
                  ? _buildConductorDetails(context, controller, isDark)
                  : _buildAbogadoDetails(context, controller, isDark, auth),
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
              onTap: () {
                controller.cambiarRol('conductor');
                if (Get.isRegistered<AuthMockController>()) {
                  Get.find<AuthMockController>().switchRole(UserRole.clientDriver, navigate: false);
                }
              },
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
              onTap: () {
                controller.cambiarRol('abogado');
                if (Get.isRegistered<AuthMockController>()) {
                  Get.find<AuthMockController>().switchRole(UserRole.associateLawyer, navigate: false);
                }
              },
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

  /// Cabecera con foto y acreditación del Abogado (Director Legal Dr. Emir Vásquez o Abogada Asociada)
  Widget _buildAbogadoHeader(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    AuthMockController? auth,
  ) {
    final isDirector = auth == null || auth.isAdminLawyer || auth.isItAdmin;

    final nombre = isDirector ? "Dr. Emir Vásquez Zambrano" : "Dra. Andrea Morales";
    final rolLabel = isDirector
        ? "Director Jurídico · Penalista y Consultor Político"
        : "Abogada Asociada en Vía";
    final matricula = isDirector
        ? "10-2012-389 · Imbabura"
        : "10-2019-512 · Imbabura";
    const entidad = "Consejo de la Judicatura del Ecuador";
    const badgeLabel = "Abogado Acreditado";

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
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDirector
                  ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF))
                  : (isDark ? const Color(0xFF0F766E) : const Color(0xFFCCFBF1)),
              border: Border.all(
                color: isDirector ? const Color(0xFF2563EB) : const Color(0xFF0F766E),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDirector ? const Color(0xFF2563EB) : const Color(0xFF0F766E))
                      .withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                isDirector ? "EV" : "AM",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: isDirector ? const Color(0xFF2563EB) : const Color(0xFF0F766E),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            nombre,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            rolLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDirector
                  ? (isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8))
                  : (isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E)),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: (isDirector ? const Color(0xFF1D4ED8) : const Color(0xFF0F766E))
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isDirector ? const Color(0xFF1D4ED8) : const Color(0xFF0F766E))
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  size: 14,
                  color: isDirector ? const Color(0xFF1D4ED8) : const Color(0xFF0F766E),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    badgeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDirector ? const Color(0xFF1D4ED8) : const Color(0xFF0F766E),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Matrícula: $matricula",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entidad,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Detalles completos del Abogado (Director Legal Dr. Emir Vásquez o Asociada)
  Widget _buildAbogadoDetails(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    AuthMockController? auth,
  ) {
    final isDirector = auth == null || auth.isAdminLawyer || auth.isItAdmin;

    if (isDirector) {
      return Column(
        children: [
          // Banner de Perfil y Trayectoria
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFBBF7D0),
                width: 1.2,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Perfil y Trayectoria",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Emir Vásquez Zambrano es un abogado penalista, consultor político ecuatoriano y magíster en derecho penal y consultoría política, con destacada actividad pública y profesional en la provincia de Imbabura y el Ecuador.",
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tarjeta 1: Acreditación y Títulos Profesionales
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.account_balance_rounded,
            iconColor: const Color(0xFF1D4ED8),
            title: "Acreditación y Títulos Profesionales",
            subtitle: "Registro oficial del Consejo de la Judicatura del Ecuador",
            rows: [
              _buildDataRow("Profesión", "Abogado Penalista y Consultor Político", isDark, highlight: true),
              _buildDataRow("Matrícula Foro", "10-2012-389 · Imbabura / Corte Nacional", isDark, highlight: true),
              _buildDataRow("Ente Rector", "Consejo de la Judicatura del Ecuador", isDark),
              _buildDataRow("Título de Grado", "Abogado de los Tribunales y Juzgados de la República", isDark),
              _buildDataRow("Maestría Penal", "Magíster en Derecho Penal", isDark, success: true),
              _buildDataRow("Maestría Consultoría", "Máster en Consultoría Política (MAICOP)", isDark, success: true),
              _buildDataRow("Especialización", "Especialización en Gestión de Gobiernos y Campañas", isDark),
            ],
          ),
          const SizedBox(height: 16),

          // Tarjeta 2: Reconocimientos y Participación Académica
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.emoji_events_rounded,
            iconColor: const Color(0xFFF59E0B),
            title: "Reconocimientos y Participación Académica",
            subtitle: "Galardones internacionales, docencia y análisis en medios",
            rows: [
              _buildDataRow("Galardones Internacionales", "Premios Golden Victory Awards", isDark, highlight: true),
              _buildDataRow("Reconocimiento Nacional", "Condecoración Eloy Alfaro", isDark, highlight: true),
              _buildDataRow("Participación Académica", "Conferencista en la Cumbre Mundial de Comunicación Política", isDark, success: true),
              _buildDataRow("En Medios de Comunicación", "Invitado frecuente y analista de coyuntura en Radio Gran Colombia y medios de Imbabura", isDark),
              _buildDataRow("Red Social Oficial", "@Emir_Vasquez (X / Twitter)", isDark, highlight: true),
            ],
          ),
          const SizedBox(height: 16),

          // Tarjeta 3: Despacho y Cobertura Territorial
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.shield_rounded,
            iconColor: const Color(0xFF0F766E),
            title: "Despacho y Cobertura Territorial",
            subtitle: "Dirección estratégica de la red de auxilio vial LegalTech",
            rows: [
              _buildDataRow("Disponibilidad", "Dirección y Supervisión de Red Vial 24/7", isDark, success: true),
              _buildDataRow("Despacho Matriz", "Vásquez & Asociados · Central Nacional LegalTech", isDark),
              _buildDataRow("Jurisdicción Principal", "Provincia de Imbabura (Ibarra, Otavalo, Cotacachi) & Cobertura Nacional", isDark, highlight: true),
              _buildDataRow("Teléfono Directo", "+593 98 776 5544", isDark, highlight: true),
              _buildDataRow("Correo Institucional", "emir.vasquez@legaltech.ec", isDark),
              _buildDataRow("Litigación & Defensas", "Más de 1.800 procesos penales y peritajes viales resueltos", isDark, success: true),
            ],
          ),
          const SizedBox(height: 16),

          // Tarjeta 4: Servicio y Asistencia 24/7 Activa
          _buildInfoCard(
            isDark: isDark,
            icon: Icons.support_agent_rounded,
            iconColor: const Color(0xFF10B981),
            title: "Servicio y Asistencia 24/7 Activa",
            subtitle: "Supervisión permanente y escalamiento inmediato ante demoras",
            rows: [
              _buildDataRow("Disponibilidad", "Monitoreo Continuo 24 Horas al Día", isDark, success: true),
              _buildDataRow("Protocolo de Escalamiento", "Notificación automática al Dr. Emir Vásquez si el abogado asociado no toma el caso a tiempo", isDark, highlight: true),
              _buildDataRow("Defensa Inmediata", "Flagrancias, Audiencias COIP y Tránsito", isDark),
              _buildDataRow("Línea de Urgencias", "+593 98 776 5544", isDark, highlight: true),
            ],
          ),
        ],
      );
    }

    // Perfil Abogada Asociada en Territorio (Dra. Andrea Morales)
    return Column(
      children: [
        // Tarjeta Acreditación Judicial Asociada
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFF0F766E),
          title: "Acreditación y Títulos Profesionales",
          subtitle: "Registro oficial del Consejo de la Judicatura del Ecuador",
          rows: [
            _buildDataRow("Matrícula Foro", "10-2019-512 · Imbabura", isDark, highlight: true),
            _buildDataRow("Ente Rector", "Consejo de la Judicatura del Ecuador", isDark),
            _buildDataRow("Título de Grado", "Abogada de los Tribunales y Juzgados de la República", isDark),
            _buildDataRow("Alma Máter", "Universidad Técnica del Norte", isDark),
            _buildDataRow("Especialidad", "Especialista Superior en Derecho Penal y Tránsito (COIP)", isDark),
            _buildDataRow("Maestría", "Magíster en Litigación Oral y Solución de Controversias", isDark),
          ],
        ),
        const SizedBox(height: 16),

        // Tarjeta Despacho y Cobertura Territorial
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFF3B82F6),
          title: "Despacho y Cobertura Territorial",
          subtitle: "Jurisdicción asignada para asistencia presencial inmediata",
          rows: [
            _buildDataRow("Disponibilidad", "Servicio Activo 24/7 (Monitoreo Continuo)", isDark, success: true),
            _buildDataRow("Jurisdicción Asignada", "Ibarra · Provincia de Imbabura", isDark, highlight: true),
            _buildDataRow("Supervisión Inmediata", "Dr. Emir Vásquez Zambrano (Dirección Legal)", isDark),
            _buildDataRow("Línea Móvil de Turno", "+593 99 445 1200", isDark, highlight: true),
            _buildDataRow("Experiencia en Vía", "+8 años en auxilio inmediato y peritajes de tránsito", isDark),
            _buildDataRow("Casos Atendidos", "Más de 380 siniestros resueltos con éxito", isDark, success: true),
          ],
        ),
        const SizedBox(height: 16),

        // Tarjeta Servicio y Asistencia 24/7 Activa
        _buildInfoCard(
          isDark: isDark,
          icon: Icons.support_agent_rounded,
          iconColor: const Color(0xFF10B981),
          title: "Servicio y Asistencia 24/7 Activa",
          subtitle: "Cobertura ininterrumpida y alerta al Director Legal",
          rows: [
            _buildDataRow("Disponibilidad", "Servicio y Guardia Activa 24 Horas", isDark, success: true),
            _buildDataRow("Monitoreo Permanente", "Los abogados asociados deben estar atentos de inmediato", isDark, highlight: true),
            _buildDataRow("Protocolo de Escalamiento", "Casos no tomados a tiempo se notifican al Dr. Emir Vásquez", isDark, highlight: true),
            _buildDataRow("Jurisdicción Operativa", "Ibarra, Otavalo, Cotacachi y red vial de Imbabura", isDark),
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
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
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
    if (esConductor) {
      return OutlinedButton.icon(
        onPressed: () => _mostrarDialogoConfirmarCerrarSesion(context),
        icon: const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
        label: const Text(
          "Cerrar Sesión",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.redAccent),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton.icon(
            onPressed: () {
              if (Get.isRegistered<AuthMockController>() && Get.find<AuthMockController>().isAssociateLawyer) {
                Get.toNamed(RouteHelper.getLawyerWorkspaceRoute());
              } else {
                Get.toNamed(RouteHelper.getEdutechRoute());
              }
            },
            icon: const Icon(
              Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 18,
            ),
            label: const Text(
              "Ir al Panel de Casos",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
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
            onPressed: () => _mostrarDialogoConfirmarCerrarSesion(context),
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