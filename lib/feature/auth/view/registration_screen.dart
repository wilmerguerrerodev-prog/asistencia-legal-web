import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/utils/images.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _licenciaController = TextEditingController();
  final TextEditingController _cooperativaController = TextEditingController();
  final TextEditingController _unidadController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();

  bool _aceptaTerminos = true;
  bool _consultandoCedula = false;
  bool _cedulaVerificada = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _licenciaController.text = "Tipo C Profesional (30 Puntos)";
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _celularController.dispose();
    _licenciaController.dispose();
    _cooperativaController.dispose();
    _unidadController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  /// Consulta inteligente de Cédula (simulada para demo / lista para conectar al endpoint de Python)
  Future<void> _consultarCedula(String cedula) async {
    final cleanCedula = cedula.trim();
    if (cleanCedula.length != 10) {
      Get.snackbar(
        "Cédula Incompleta",
        "Por favor ingresa los 10 dígitos de tu cédula ecuatoriana.",
        backgroundColor: const Color(0xFFD97706),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    setState(() {
      _consultandoCedula = true;
      _cedulaVerificada = false;
    });

    // Simula consulta de 1 segundo al servicio de Python / Registro Civil / ANT
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _consultandoCedula = false;
      _cedulaVerificada = true;
      if (_nombreController.text.isEmpty) {
        _nombreController.text = "Carlos Alberto Mendoza";
      }
      if (_celularController.text.isEmpty) {
        _celularController.text = "+593 98 765 4321";
      }
      _licenciaController.text = "Tipo C Profesional (30 Puntos ANT)";
    });

    Get.snackbar(
      "✓ Cédula Verificada",
      "Identidad y Licencia Profesional validadas ante ANT / Registro Civil.",
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.verified_rounded, color: Colors.white),
    );
  }

  void _registrarConductor() async {
    if (!_aceptaTerminos) {
      Get.snackbar(
        "Términos requeridos",
        "Debes aceptar los términos de cobertura legal para activar la protección.",
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    final nombre = _nombreController.text.trim().isNotEmpty
        ? _nombreController.text.trim()
        : "Carlos Mendoza";
    final cooperativa = _cooperativaController.text.trim().isNotEmpty
        ? _cooperativaController.text.trim()
        : "Cooperativa Los Lagos";
    final unidad = _unidadController.text.trim().isNotEmpty
        ? _unidadController.text.trim()
        : "Unidad #42";
    final placa = _placaController.text.trim().isNotEmpty
        ? _placaController.text.trim().toUpperCase()
        : "IBA-1234";

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final ConductorController conductorController = Get.isRegistered<ConductorController>()
        ? Get.find<ConductorController>()
        : Get.put(ConductorController());

    conductorController.actualizarDatosConductor(
      nombre: nombre,
      unidad: unidad,
      cooperativaNombre: cooperativa,
      placa: placa,
      telefono: _celularController.text.trim().isNotEmpty
          ? _celularController.text.trim()
          : "+593 98 765 4321",
      cedula: _cedulaController.text.trim().isNotEmpty
          ? _cedulaController.text.trim()
          : "1002345678",
      licencia: _licenciaController.text.trim(),
    );

    setState(() => _isLoading = false);

    Get.snackbar(
      "¡Protección Legal Activa!",
      "Tu taxi $unidad de $cooperativa cuenta con respaldo legal 24/7.",
      backgroundColor: const Color(0xFF16A34A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.shield_rounded, color: Colors.white),
    );

    Get.offAllNamed(RouteHelper.initial);
  }

  void _completarConGoogle() async {
    setState(() {
      _nombreController.text = "Carlos Alberto Mendoza";
      _cedulaController.text = "1002345678";
      _celularController.text = "+593 98 765 4321";
      _cooperativaController.text = "Cooperativa Los Lagos";
      _unidadController.text = "Unidad #42";
      _placaController.text = "IBA-1234";
      _cedulaVerificada = true;
    });

    Get.snackbar(
      "Datos cargados desde Google",
      "Completa o verifica los datos de tu taxi para finalizar.",
      backgroundColor: const Color(0xFF2563EB),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
    );
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
              vertical: isMobile ? 16 : 32,
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 520),
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
                  // 1. Cabecera
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
                          child: Icon(Icons.app_registration_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "LegalTech",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const Text(
                              "PROTECCIÓN VIAL INMEDIATA",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "Registro de Conductor",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Activa el auxilio legal inmediato para ti y tu vehículo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Botón Google
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                    ),
                    onPressed: _completarConGoogle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(Images.google, height: 20, width: 20),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            "Registrarse con Google",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Divisor
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "o completa tu ficha",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // --- SECCIÓN 1: DATOS PERSONALES & CÉDULA INTELIGENTE ---
                  _buildSeccionHeader(
                    icono: Icons.person_rounded,
                    titulo: "DATOS PERSONALES Y LICENCIA",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  // Campo Cédula con botón Consultar Inteligente
                  Text(
                    "Cédula de Identidad (10 dígitos)",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _cedulaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (val) {
                      if (_cedulaVerificada) {
                        setState(() => _cedulaVerificada = false);
                      }
                    },
                    onSubmitted: (val) {
                      if (val.trim().length == 10 && !_cedulaVerificada) {
                        _consultarCedula(val);
                      }
                    },
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "Ej. 1002345678",
                      hintStyle: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: isDark ? Colors.white30 : const Color(0xFF94A3B8),
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20, color: Color(0xFF2563EB)),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(6),
                        child: _consultandoCedula
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: Padding(
                                  padding: EdgeInsets.all(4),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : InkWell(
                                onTap: () => _consultarCedula(_cedulaController.text),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _cedulaVerificada
                                        ? const Color(0xFF16A34A).withValues(alpha: 0.15)
                                        : const Color(0xFF2563EB).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _cedulaVerificada ? Icons.check_circle_rounded : Icons.search_rounded,
                                        size: 15,
                                        color: _cedulaVerificada
                                            ? const Color(0xFF16A34A)
                                            : const Color(0xFF2563EB),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _cedulaVerificada ? "Verificada" : "Consultar",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: _cedulaVerificada
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFF2563EB),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                          color: _cedulaVerificada
                              ? const Color(0xFF16A34A)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Nombres y Apellidos
                  Text(
                    "Nombres y Apellidos",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _nombreController,
                    hint: "Ej. Carlos Alberto Mendoza",
                    icon: Icons.person_outline_rounded,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),

                  // Celular y Tipo de Licencia en 2 Columnas
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Teléfono / WhatsApp",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _celularController,
                              hint: "+593 98 765 4321",
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Licencia y Puntos",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _licenciaController,
                              hint: "Tipo C (30 Puntos)",
                              icon: Icons.credit_card_rounded,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- SECCIÓN 2: DATOS DEL VEHÍCULO / UNIDAD ---
                  _buildSeccionHeader(
                    icono: Icons.local_taxi_rounded,
                    titulo: "DATOS DEL VEHÍCULO / UNIDAD",
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  // Cooperativa
                  Text(
                    "Cooperativa o Compañía de Taxis",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _cooperativaController,
                    hint: "Ej. Cooperativa Los Lagos",
                    icon: Icons.business_rounded,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 12),

                  // Unidad y Placa en 2 Columnas
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Número de Unidad",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _unidadController,
                              hint: "Ej. Unidad #42",
                              icon: Icons.tag_rounded,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Placa del Taxi",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF334155),
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _placaController,
                              hint: "Ej. IBA-1234",
                              icon: Icons.directions_car_rounded,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Checkbox Términos
                  Row(
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: _aceptaTerminos,
                          activeColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (val) => setState(() => _aceptaTerminos = val ?? true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Acepto los términos de auxilio vial y patrocinio legal en ruta.",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botón Principal
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
                    onPressed: _isLoading ? null : _registrarConductor,
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
                            "Completar Registro y Activar Protección",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Enlace a Login
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "¿Ya tienes cuenta registrada? ",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(RouteHelper.loginScreen),
                        child: const Text(
                          "Inicia sesión",
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

  Widget _buildSeccionHeader({
    required IconData icono,
    required String titulo,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icono, size: 16, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 13.5,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
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
      ),
    );
  }
}
