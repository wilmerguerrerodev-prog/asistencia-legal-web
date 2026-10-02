import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/core/services/firebase_service.dart';
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
  MockUser? _selectedDemoUser;

  @override
  void dispose() {
    _identificacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _iniciarSesion({MockUser? usuarioPreconfigurado}) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final ConductorController conductorController = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    final AuthMockController authController = Get.isRegistered<AuthMockController>()
        ? Get.find<AuthMockController>()
        : Get.put(AuthMockController(), permanent: true);

    MockUser? userToLogin;

    if (usuarioPreconfigurado != null) {
      userToLogin = usuarioPreconfigurado;
      _identificacionController.text = userToLogin.email;
      _passwordController.text = "123456";
    } else {
      final idText = _identificacionController.text.trim();
      final passText = _passwordController.text.trim();

      if (idText.isEmpty) {
        setState(() => _isLoading = false);
        Get.snackbar(
          "Campo requerido",
          "Por favor ingresa tu cédula o correo (o toca un acceso rápido demo).",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // Si ingresó cédula o correo y contraseña
      if (passText.isNotEmpty) {
        String emailToUse = idText;
        Map<String, dynamic>? firestoreData;
        final authController = Get.isRegistered<AuthMockController>()
            ? Get.find<AuthMockController>()
            : Get.put(AuthMockController(), permanent: true);
        final localUser = authController.findUserByIdentifier(idText);

        try {
          // Si es cédula (no contiene @): buscar correo registrado en Firestore o local
          if (!idText.contains('@')) {
            if (localUser != null) {
              emailToUse = localUser.email;
            }
            final userDoc = await FirebaseService().getUserByCedula(idText);
            if (userDoc != null) {
              firestoreData = userDoc;
              emailToUse = userDoc['email'] ?? emailToUse;
            } else if (localUser == null) {
              emailToUse = '$idText@legaltech.ec';
            }
          } else {
            // Si es correo electrónico: buscar en Firestore por email
            final userDoc = await FirebaseService().getUserByEmail(idText);
            if (userDoc != null) {
              firestoreData = userDoc;
            }
          }

          final cred = await FirebaseService().signIn(email: emailToUse, password: passText);
          if (cred?.user != null) {
            final doc = await FirebaseService().getUserProfile(cred!.user!.uid);
            final data = doc.data() ?? firestoreData;
            if (data != null) {
              final roleStr = data['role'] ?? 'clientDriver';
              final userRole = UserRole.values.firstWhere(
                (r) => r.name == roleStr,
                orElse: () => UserRole.clientDriver,
              );

              userToLogin = MockUser(
                id: cred.user!.uid,
                name: data['name'] ?? idText,
                email: emailToUse,
                role: userRole,
                cooperativeId: data['cooperativeId'],
                cooperativeName: data['cooperativeName'],
                canton: data['canton'] ?? (userRole == UserRole.clientDriver ? 'Otavalo' : 'Ibarra'),
                phone: data['phone'],
                debeCambiarClave: data['debeCambiarClave'] == true,
                matriculaForo: data['matriculaForo'],
                cedula: data['cedula'] ?? (idText.contains('@') ? null : idText),
                placa: data['placa'],
                unidadTaxi: data['unidadTaxi'],
                licencia: data['licencia'],
                foto: data['foto'],
              );
            } else if (_selectedDemoUser != null &&
                _selectedDemoUser!.email.toLowerCase() == emailToUse.toLowerCase()) {
              userToLogin = _selectedDemoUser!.copyWith(
                id: cred.user!.uid,
                email: emailToUse,
              );
            } else if (localUser != null) {
              userToLogin = localUser.copyWith(
                id: cred.user!.uid,
                email: emailToUse,
              );
            } else {
              // Deducir rol exacto según el correo ingresado si no hay doc en Firestore
              final lower = emailToUse.toLowerCase();
              if (lower.contains('admin') || lower.contains('sistemas') || lower.contains('it@') || lower.contains('it.')) {
                userToLogin = AuthMockController.mockItAdmin.copyWith(id: cred.user!.uid, email: emailToUse);
              } else if (lower.contains('director') || lower.contains('emir')) {
                userToLogin = AuthMockController.mockAdminLawyer.copyWith(id: cred.user!.uid, email: emailToUse);
              } else if (lower.contains('revelo') || lower.contains('temporal')) {
                userToLogin = AuthMockController.mockTempLawyer.copyWith(id: cred.user!.uid, email: emailToUse);
              } else if (lower.contains('abogado') || lower.contains('andrea') || lower.contains('morales')) {
                userToLogin = AuthMockController.mockAssociateLawyer.copyWith(id: cred.user!.uid, email: emailToUse);
              } else {
                userToLogin = AuthMockController.mockClientDriver.copyWith(
                  id: cred.user!.uid,
                  name: cred.user!.email?.split('@').first ?? 'Conductor',
                  email: emailToUse,
                  cedula: idText.contains('@') ? null : idText,
                );
              }
            }
          }
        } catch (e) {
          final errStr = e.toString().toLowerCase();
          final isWrongPassword = errStr.contains('wrong-password') ||
              errStr.contains('invalid-credential') ||
              errStr.contains('invalid_login_credentials') ||
              errStr.contains('wrongpassword');

          if (isWrongPassword) {
            setState(() => _isLoading = false);
            final yaCambioClave = (firestoreData != null && firestoreData['debeCambiarClave'] == false) ||
                (localUser != null && localUser.debeCambiarClave == false);

            Get.snackbar(
              "Contraseña incorrecta",
              yaCambioClave
                  ? "La clave temporal anterior ya expiró. Por favor ingresa con tu nueva contraseña."
                  : "La contraseña ingresada no es válida para esta cuenta.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFEF4444),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
              duration: const Duration(seconds: 4),
              icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
            );
            return;
          }

          debugPrint('Firebase Auth no disponible o modo offline: $e');
        }

        if (userToLogin == null) {
          // Fallback seguro en modo local / offline con validación estricta de clave
          if (localUser != null) {
            final bool isValidPass;
            if (localUser.temporaryPassword != null && localUser.temporaryPassword!.isNotEmpty) {
              isValidPass = (passText == localUser.temporaryPassword);
            } else {
              isValidPass = (passText == '123456' ||
                  passText == 'conductor123' ||
                  passText == 'abogado123' ||
                  passText == 'director123' ||
                  passText == 'admin123');
            }

            if (!isValidPass) {
              setState(() => _isLoading = false);
              Get.snackbar(
                "Contraseña incorrecta",
                localUser.debeCambiarClave == false
                    ? "La clave temporal anterior ya expiró. Por favor ingresa con tu nueva contraseña."
                    : "La contraseña ingresada no es válida para este usuario.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFFEF4444),
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
                duration: const Duration(seconds: 4),
                icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
              );
              return;
            }

            userToLogin = localUser;
          } else if (_selectedDemoUser != null &&
              _selectedDemoUser!.email.toLowerCase() == emailToUse.toLowerCase()) {
            userToLogin = _selectedDemoUser!;
          } else if (firestoreData != null) {
            final roleStr = firestoreData['role'] ?? 'clientDriver';
            final userRole = UserRole.values.firstWhere(
              (r) => r.name == roleStr,
              orElse: () => UserRole.clientDriver,
            );
            userToLogin = MockUser(
              id: firestoreData['id'] ?? 'USER-OFFLINE',
              name: firestoreData['name'] ?? idText,
              email: firestoreData['email'] ?? emailToUse,
              role: userRole,
              cooperativeId: firestoreData['cooperativeId'],
              cooperativeName: firestoreData['cooperativeName'],
              canton: firestoreData['canton'] ?? (userRole == UserRole.clientDriver ? 'Otavalo' : 'Ibarra'),
              phone: firestoreData['phone'],
              debeCambiarClave: firestoreData['debeCambiarClave'] == true,
              matriculaForo: firestoreData['matriculaForo'],
              cedula: firestoreData['cedula'] ?? (idText.contains('@') ? null : idText),
              placa: firestoreData['placa'],
              unidadTaxi: firestoreData['unidadTaxi'],
              licencia: firestoreData['licencia'],
              foto: firestoreData['foto'],
            );
          } else {
            final lower = emailToUse.toLowerCase();
            if (lower.contains('admin') || lower.contains('sistemas') || lower.contains('it@') || lower.contains('it.')) {
              userToLogin = AuthMockController.mockItAdmin;
            } else if (lower.contains('director') || lower.contains('emir')) {
              userToLogin = AuthMockController.mockAdminLawyer;
            } else if (lower.contains('revelo') || lower.contains('temporal')) {
              userToLogin = AuthMockController.mockTempLawyer;
            } else if (lower.contains('abogado') || lower.contains('andrea') || lower.contains('morales')) {
              userToLogin = AuthMockController.mockAssociateLawyer;
            } else {
              userToLogin = AuthMockController.mockClientDriver.copyWith(
                cedula: idText.contains('@') ? null : idText,
                email: emailToUse,
              );
            }
          }
        }
      } else {
        // Fallback cuando solo escribió texto sin contraseña (o acceso rápido)
        final authController = Get.isRegistered<AuthMockController>()
            ? Get.find<AuthMockController>()
            : Get.put(AuthMockController(), permanent: true);
        final localUser = authController.findUserByIdentifier(idText);

        if (_selectedDemoUser != null &&
            _selectedDemoUser!.email.toLowerCase() == idText.toLowerCase()) {
          userToLogin = _selectedDemoUser!;
        } else if (localUser != null) {
          userToLogin = localUser;
        } else {
          final lower = idText.toLowerCase();
          if (lower.contains('director') || lower.contains('emir')) {
            userToLogin = AuthMockController.mockAdminLawyer;
          } else if (lower.contains('admin') || lower.contains('sistemas') || lower.contains('it@') || lower.contains('it.')) {
            userToLogin = AuthMockController.mockItAdmin;
          } else if (lower.contains('revelo') || lower.contains('temporal')) {
            userToLogin = AuthMockController.mockTempLawyer;
          } else if (lower.contains('abogado') || lower.contains('andrea') || lower.contains('morales')) {
            userToLogin = AuthMockController.mockAssociateLawyer;
          } else {
            userToLogin = AuthMockController.mockClientDriver.copyWith(
              cedula: idText.contains('@') ? null : idText,
              email: idText.contains('@') ? idText : '$idText@legaltech.ec',
            );
          }
        }
      }
    }

    if (userToLogin.role == UserRole.clientDriver) {
      conductorController.cambiarRol('conductor');
      conductorController.actualizarDatosConductor(
        nombre: userToLogin.name,
        unidad: userToLogin.unidadTaxi ?? "Unidad #42",
        cooperativaNombre: userToLogin.cooperativeName ?? conductorController.cooperativa,
        placa: userToLogin.placa ?? "IBA-1234",
        telefono: userToLogin.phone ?? conductorController.telefonoConductor,
        cedula: userToLogin.cedula ?? "1002345678",
        licencia: userToLogin.licencia ?? "Tipo C Profesional (30 Puntos)",
        foto: userToLogin.foto,
      );
    } else if (userToLogin.role == UserRole.itAdmin) {
      conductorController.cambiarRol('admin');
    } else {
      conductorController.cambiarRol('abogado');
    }

    setState(() => _isLoading = false);

    final esAbogado = userToLogin.role != UserRole.clientDriver;

    Get.snackbar(
      '${userToLogin.role.iconEmoji} ${userToLogin.role.displayName}',
      'Sesión iniciada correctamente como ${userToLogin.name}',
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

    // Notificar al sistema operativo (iOS Llavero de iCloud / Android Google Autofill) para guardar credenciales
    TextInput.finishAutofillContext();

    authController.switchUser(userToLogin, navigate: true);
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
                        width: 52,
                        height: 52,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/legaltech_logo.png',
                          fit: BoxFit.contain,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
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

                  // 3. Formulario de Credenciales con Autocompletado del Sistema (iCloud Keychain / Google)
                  AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          autofillHints: const [AutofillHints.username, AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            if (_selectedDemoUser != null &&
                                val.trim().toLowerCase() != _selectedDemoUser!.email.toLowerCase()) {
                              setState(() => _selectedDemoUser = null);
                            }
                          },
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
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _iniciarSesion(),
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
                      ],
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
                    onPressed: _isLoading ? null : () => _iniciarSesion(),
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

                  // Accesos Rápidos Demo (1 Toque)
                  _buildDemoQuickAccess(context, isDark),

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

  Widget _buildDemoQuickAccess(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "CREDENCIALES DEL SISTEMA",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                ),
              ),
            ),
            Expanded(child: Divider(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "Cuentas oficiales registradas en Firebase:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11.5,
            color: isDark ? Colors.white60 : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        // Grilla 2x2 compacta de credenciales oficiales
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCredentialChip(
              context: context,
              isDark: isDark,
              emoji: "💻",
              rol: "Admin TI",
              email: "admin@legaltech.ec",
              pass: "admin123",
              accentColor: const Color(0xFFD97706),
              user: AuthMockController.mockItAdmin,
            ),
            _buildCredentialChip(
              context: context,
              isDark: isDark,
              emoji: "⚖️",
              rol: "Director",
              email: "emir@legaltech.ec",
              pass: "emir123",
              accentColor: const Color(0xFF7C3AED),
              user: AuthMockController.mockAdminLawyer,
            ),
            _buildCredentialChip(
              context: context,
              isDark: isDark,
              emoji: "🛡️",
              rol: "Abogada",
              email: "abogado@legaltech.ec",
              pass: "abogado123",
              accentColor: const Color(0xFF0F766E),
              user: AuthMockController.mockAssociateLawyer,
            ),
            _buildCredentialChip(
              context: context,
              isDark: isDark,
              emoji: "🚖",
              rol: "Conductor",
              email: "conductor@legaltech.ec",
              pass: "conductor123",
              accentColor: const Color(0xFF2563EB),
              user: AuthMockController.mockClientDriver,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCredentialChip({
    required BuildContext context,
    required bool isDark,
    required String emoji,
    required String rol,
    required String email,
    required String pass,
    required Color accentColor,
    required MockUser user,
  }) {
    final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 400;
    final cardWidth = (screenWidth > 500 ? 500 : screenWidth) / 2 - 32;
    final isSelected = _selectedDemoUser?.role == user.role ||
        _identificacionController.text.trim().toLowerCase() == email.toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _identificacionController.text = email;
            _passwordController.text = pass;
            _selectedDemoUser = user;
          });
          HapticFeedback.selectionClick();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? accentColor.withValues(alpha: isDark ? 0.22 : 0.12)
                : (isDark ? const Color(0xFF0F172A) : Colors.white),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? accentColor : accentColor.withValues(alpha: 0.35),
              width: isSelected ? 1.8 : 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    rol,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                    ),
                  ),
                  if (isSelected) ...[
                    const Spacer(),
                    Icon(Icons.check_circle_rounded, size: 14, color: accentColor),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                email,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Clave: $pass",
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
