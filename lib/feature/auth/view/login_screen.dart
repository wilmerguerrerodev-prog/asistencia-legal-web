import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identificacionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _recordarSesion = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _identificacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion({bool isDemo = false}) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final ConductorController conductorController = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    if (isDemo) {
      conductorController.actualizarDatosConductor(
        nombre: "Carlos Alberto Mendoza",
        unidad: "Unidad #42",
        cooperativaNombre: "Cooperativa Los Lagos",
        placa: "IBA-1234",
        telefono: "+593 98 765 4321",
        cedula: "1002345678",
        licencia: "Tipo C Profesional (30 Puntos)",
      );
      if (Get.isRegistered<AuthMockController>()) {
        Get.find<AuthMockController>().switchRole(
          UserRole.clientDriver,
          navigate: false,
        );
      }
    } else {
      final idText = _identificacionController.text.trim();
      final esRolAbogado = idText.toLowerCase().contains('abogado') ||
          idText.toLowerCase().contains('legal');

      if (esRolAbogado) {
        conductorController.cambiarRol('abogado');
        if (Get.isRegistered<AuthMockController>()) {
          final isDirector = idText.toLowerCase().contains('director') ||
              idText.toLowerCase().contains('emir');
          Get.find<AuthMockController>().switchRole(
            isDirector ? UserRole.adminLawyer : UserRole.associateLawyer,
            navigate: false,
          );
        }
      } else {
        conductorController.cambiarRol('conductor');
        if (Get.isRegistered<AuthMockController>()) {
          Get.find<AuthMockController>().switchRole(
            UserRole.clientDriver,
            navigate: false,
          );
        }
      }

      if (idText.isNotEmpty && !esRolAbogado) {
        conductorController.actualizarDatosConductor(
          nombre: idText.contains('@') ? idText.split('@')[0] : "Conductor ($idText)",
          unidad: conductorController.unidadTaxi,
          cooperativaNombre: conductorController.cooperativa,
          placa: conductorController.placaVehiculo,
          cedula: idText,
        );
      }
    }

    setState(() => _isLoading = false);

    final esAbogado = conductorController.rolActivo.value == 'abogado';

    Get.snackbar(
      esAbogado ? "¡Bienvenido, Colega!" : "¡Bienvenido!",
      esAbogado
          ? "Accediendo al panel de Defensa Legal y Centro de Casos."
          : "Sesión iniciada correctamente. Protección legal vial activa 24/7.",
      backgroundColor: esAbogado ? const Color(0xFF0F766E) : const Color(0xFF16A34A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: Icon(
        esAbogado ? Icons.gavel_rounded : Icons.verified_user_rounded,
        color: Colors.white,
      ),
    );

    if (esAbogado) {
      final idText = _identificacionController.text.toLowerCase();
      final isDirector = idText.contains('director') || idText.contains('emir');
      if (isDirector) {
        Get.offAllNamed(RouteHelper.legalCenterScreen);
      } else {
        Get.offAllNamed(RouteHelper.lawyerWorkspaceScreen);
      }
    } else {
      Get.offAllNamed(RouteHelper.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 20 : 36,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: EdgeInsets.all(isMobile ? 20 : 28),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Logo y Título Principal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.local_taxi_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "LegalTech",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Bienvenido a LegalTech",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Iniciar Sesión",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 3. Formulario de Credenciales
                  Text(
                    "Cédula de Identidad o Correo",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _identificacionController,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Ej. 1002345678 o correo",
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20, color: Color(0xFF2563EB)),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Contraseña o PIN",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: Color(0xFF2563EB)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          size: 19,
                          color: isDark ? Colors.white54 : const Color(0xFF64748B),
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Checkbox Recordar Sesión
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _recordarSesion,
                          activeColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (val) => setState(() => _recordarSesion = val ?? true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Recordar en este teléfono",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 4. Botón Iniciar Sesión
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : () => _iniciarSesion(isDemo: false),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Enlace a Registro
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "¿Aún no tienes cuenta? ",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.registrationScreen),
                        child: const Text(
                          "Regístrate aquí",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
