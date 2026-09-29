import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/helper/responsive_helper.dart';

class RegisterLawyerDialog extends StatefulWidget {
  final Function(Map<String, dynamic> lawyerData)? onRegistered;

  const RegisterLawyerDialog({
    super.key,
    this.onRegistered,
  });

  /// Muestra el diálogo o modal responsivo para registrar nuevo abogado
  static Future<void> show(
    BuildContext context, {
    Function(Map<String, dynamic> lawyerData)? onRegistered,
  }) async {
    final isMobile = ResponsiveHelper.isMobile(context);

    if (isMobile) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.6,
          maxChildSize: 0.98,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 6),
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Expanded(
                  child: RegisterLawyerDialog(
                    onRegistered: onRegistered,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => Dialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 580, maxHeight: 820),
            child: RegisterLawyerDialog(
              onRegistered: onRegistered,
            ),
          ),
        ),
      );
    }
  }

  @override
  State<RegisterLawyerDialog> createState() => _RegisterLawyerDialogState();
}

class _RegisterLawyerDialogState extends State<RegisterLawyerDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _cantones = [
    'Ibarra',
    'Otavalo',
    'Cotacachi',
    'San Antonio',
  ];

  String _cantonSeleccionado = 'Ibarra';
  bool _isLoading = false;
  bool _obscurePassword = false;

  @override
  void initState() {
    super.initState();
    _passwordController.text = _generarPasswordTemporal();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _matriculaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _generarPasswordTemporal() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#';
    final random = Random();
    final suffix = List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    return 'LegalTech2026$suffix!';
  }

  void _regenerarPassword() {
    HapticFeedback.lightImpact();
    setState(() {
      _passwordController.text = _generarPasswordTemporal();
    });
    if (Get.overlayContext != null) {
      Get.snackbar(
        "Nueva Contraseña Autogenerada",
        _passwordController.text,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }

  void _copiarPassword() {
    Clipboard.setData(ClipboardData(text: _passwordController.text));
    HapticFeedback.lightImpact();
    if (Get.overlayContext != null) {
      Get.snackbar(
        "Contraseña Copiada",
        "La clave temporal ha sido copiada al portapapeles.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0F766E),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
      );
    }
  }

  Future<void> _guardarAbogado() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final nombre = _nombreController.text.trim();
    final cedula = _cedulaController.text.trim();
    final email = _emailController.text.trim();
    final telefono = _telefonoController.text.trim();
    final matricula = _matriculaController.text.trim();
    final passwordTemporal = _passwordController.text.trim();
    final canton = _cantonSeleccionado;

    final authController = Get.isRegistered<AuthMockController>()
        ? Get.find<AuthMockController>()
        : Get.put(AuthMockController(), permanent: true);

    // Invocación del método modular para que Darío solo conecte a Firebase
    await authController.onSaveLawyer(
      nombre: nombre,
      cedula: cedula,
      email: email,
      telefono: telefono,
      canton: canton,
      matriculaForo: matricula,
      temporaryPassword: passwordTemporal,
    );

    final lawyerData = {
      "nombre": nombre,
      "cedula": cedula,
      "email": email,
      "telefono": telefono,
      "canton": canton,
      "matricula": matricula,
      "password": passwordTemporal,
      "unidad": "Móvil Legal • $canton",
      "estado": "Disponible en Guardia",
      "color": const Color(0xFF2E7D32),
      "ubicacion": "Base Cantonal $canton",
      "vehiculo": "Vehículo Asignado",
      "casosHoy": "0 casos asignados",
      "especialidad": "Defensa en vía e investigación pericial",
    };

    widget.onRegistered?.call(lawyerData);

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Cierra el formulario
    Navigator.of(context).pop();

    // Muestra diálogo modal de confirmación con las credenciales
    _mostrarModalConfirmacionCredenciales(
      context: context,
      nombre: nombre,
      email: email,
      password: passwordTemporal,
      canton: canton,
      matricula: matricula,
    );
  }

  void _mostrarModalConfirmacionCredenciales({
    required BuildContext context,
    required String nombre,
    required String email,
    required String password,
    required String canton,
    required String matricula,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textoCredenciales = """
⚖️ LEGALTECH - CREDENCIALES TEMPORALES DE ACCESO
Estimado/a $nombre,
Se ha completado su registro en la Red de Asistencia Legal.

• Usuario/Correo: $email
• Contraseña Temporal: $password
• Cantón de Cobertura: $canton
• Matrícula Foro: $matricula

⚠️ Por políticas de seguridad, al realizar su primer ingreso deberá establecer su contraseña definitiva en su despacho virtual.
""";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono de Éxito
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF0D9488),
                      size: 34,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "¡Abogado Registrado Exitosamente!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Abogado registrado exitosamente. Entrega estas credenciales temporales al $nombre para su primer ingreso.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  height: 1.45,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                ),
              ),

              const SizedBox(height: 18),

              // Tarjeta con credenciales para entregar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    _buildCredencialRow(
                      icon: Icons.person_rounded,
                      label: "Abogado",
                      value: nombre,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildCredencialRow(
                      icon: Icons.email_rounded,
                      label: "Correo",
                      value: email,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildCredencialRow(
                      icon: Icons.lock_rounded,
                      label: "Clave Temporal",
                      value: password,
                      isDark: isDark,
                      isHighlight: true,
                    ),
                    const SizedBox(height: 8),
                    _buildCredencialRow(
                      icon: Icons.location_on_rounded,
                      label: "Cantón",
                      value: canton,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),
                    _buildCredencialRow(
                      icon: Icons.gavel_rounded,
                      label: "Matrícula Foro",
                      value: matricula,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Botones: Copiar datos y Aceptar
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.copy_all_rounded, size: 18),
                      label: const Text(
                        "Copiar datos",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: textoCredenciales));
                        HapticFeedback.lightImpact();
                        if (Get.overlayContext != null) {
                          Get.snackbar(
                            "Credenciales Copiadas",
                            "El mensaje con las credenciales ha sido copiado para enviar al abogado.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF0F766E),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                            margin: const EdgeInsets.all(14),
                            borderRadius: 12,
                            icon: const Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                      },
                      child: const Text(
                        "Aceptar",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredencialRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool isHighlight = false,
  }) {
    return Row(
      children: [
        Icon(icon,
            size: 16,
            color: isHighlight
                ? const Color(0xFF2563EB)
                : (isDark ? Colors.white54 : const Color(0xFF64748B))),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : const Color(0xFF475569),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: isHighlight ? 'Montserrat' : 'Plus Jakarta Sans',
              fontSize: 12.5,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
              color: isHighlight
                  ? const Color(0xFF2563EB)
                  : (isDark ? Colors.white : const Color(0xFF0F172A)),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? 18 : 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabecera del formulario
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Color(0xFF2563EB),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Registrar Nuevo Abogado",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Alta de defensores • Despacho Director & TI",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 1. Nombre Completo
              _buildFieldLabel("Nombre Completo (ej: Dr. Carlos Revelo)", isDark),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nombreController,
                textCapitalization: TextCapitalization.words,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Por favor ingresa el nombre del abogado.";
                  }
                  if (val.trim().length < 3) {
                    return "El nombre debe tener al menos 3 caracteres.";
                  }
                  return null;
                },
                decoration: _inputDecoration(
                  hint: "Ej. Dr. Carlos Revelo",
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                ),
                style: _inputTextStyle(isDark),
              ),

              const SizedBox(height: 14),

              // 2. Cédula y Teléfono en Fila o Columna
              if (isMobile) ...[
                _buildFieldLabel("Cédula de Identidad (10 dígitos)", isDark),
                const SizedBox(height: 6),
                _buildCedulaField(isDark),
                const SizedBox(height: 14),
                _buildFieldLabel("Celular / Teléfono", isDark),
                const SizedBox(height: 6),
                _buildTelefonoField(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(
                              "Cédula de Identidad (10 dígitos)", isDark),
                          const SizedBox(height: 6),
                          _buildCedulaField(isDark),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Celular / Teléfono", isDark),
                          const SizedBox(height: 6),
                          _buildTelefonoField(isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              // 3. Correo Electrónico Profesional
              _buildFieldLabel("Correo Electrónico Profesional", isDark),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Por favor ingresa el correo profesional.";
                  }
                  final emailRegex =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(val.trim())) {
                    return "Ingresa un correo electrónico válido.";
                  }
                  return null;
                },
                decoration: _inputDecoration(
                  hint: "ejemplo@legaltech.ec",
                  icon: Icons.alternate_email_rounded,
                  isDark: isDark,
                ),
                style: _inputTextStyle(isDark),
              ),

              const SizedBox(height: 14),

              // 4. Cantón de Cobertura y Matrícula del Foro
              if (isMobile) ...[
                _buildFieldLabel("Cantón de Cobertura", isDark),
                const SizedBox(height: 6),
                _buildCantonDropdown(isDark),
                const SizedBox(height: 14),
                _buildFieldLabel("Matrícula del Foro de Abogados", isDark),
                const SizedBox(height: 6),
                _buildMatriculaField(isDark),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Cantón de Cobertura", isDark),
                          const SizedBox(height: 6),
                          _buildCantonDropdown(isDark),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(
                              "Matrícula del Foro de Abogados", isDark),
                          const SizedBox(height: 6),
                          _buildMatriculaField(isDark),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              // 5. Contraseña Temporal Autogenerada con botón Copiar y Regenerar
              _buildFieldLabel("Contraseña Temporal (Editable)", isDark),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "La contraseña temporal no puede estar vacía.";
                  }
                  if (val.trim().length < 6) {
                    return "Mínimo 6 caracteres para la clave temporal.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "LegalTech2026!",
                  hintStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(Icons.vpn_key_rounded,
                      size: 20, color: Color(0xFF2563EB)),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Regenerar clave aleatoria",
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        onPressed: _regenerarPassword,
                      ),
                      IconButton(
                        tooltip: "Copiar clave al portapapeles",
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        onPressed: _copiarPassword,
                      ),
                      IconButton(
                        tooltip: _obscurePassword ? "Ver clave" : "Ocultar clave",
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 19,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ],
                  ),
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                  ),
                ),
                style: _inputTextStyle(isDark),
              ),

              const SizedBox(height: 10),

              // Nota explicativa
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 16, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "El abogado deberá cambiar esta contraseña en su primer inicio de sesión.",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: isDark ? Colors.white70 : const Color(0xFF1E40AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botones de Acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 13),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _guardarAbogado,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(
                      _isLoading ? "Guardando..." : "Guardar Abogado",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white70 : const Color(0xFF334155),
      ),
    );
  }

  Widget _buildCedulaField(bool isDark) {
    return TextFormField(
      controller: _cedulaController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return "Ingresa la cédula de identidad.";
        }
        if (val.trim().length != 10) {
          return "La cédula debe tener exactamente 10 dígitos.";
        }
        return null;
      },
      decoration: _inputDecoration(
        hint: "10 dígitos numéricos",
        icon: Icons.credit_card_rounded,
        isDark: isDark,
      ),
      style: _inputTextStyle(isDark),
    );
  }

  Widget _buildTelefonoField(bool isDark) {
    return TextFormField(
      controller: _telefonoController,
      keyboardType: TextInputType.phone,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return "Ingresa el teléfono celular.";
        }
        if (val.trim().length < 8) {
          return "Ingresa un número telefónico válido.";
        }
        return null;
      },
      decoration: _inputDecoration(
        hint: "+593 99 123 4567",
        icon: Icons.phone_android_rounded,
        isDark: isDark,
      ),
      style: _inputTextStyle(isDark),
    );
  }

  Widget _buildMatriculaField(bool isDark) {
    return TextFormField(
      controller: _matriculaController,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return "Ingresa la matrícula del Foro de Abogados.";
        }
        return null;
      },
      decoration: _inputDecoration(
        hint: "Ej. 10-2022-315-CJ",
        icon: Icons.gavel_rounded,
        isDark: isDark,
      ),
      style: _inputTextStyle(isDark),
    );
  }

  Widget _buildCantonDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      initialValue: _cantonSeleccionado,
      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      items: _cantones.map((c) {
        return DropdownMenuItem<String>(
          value: c,
          child: Text(
            c,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() => _cantonSeleccionado = val);
        }
      },
      decoration: _inputDecoration(
        hint: "Selecciona cantón",
        icon: Icons.map_rounded,
        isDark: isDark,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 13,
        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
      ),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF2563EB)),
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
    );
  }

  TextStyle _inputTextStyle(bool isDark) {
    return TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 13.5,
      color: isDark ? Colors.white : const Color(0xFF0F172A),
    );
  }
}
