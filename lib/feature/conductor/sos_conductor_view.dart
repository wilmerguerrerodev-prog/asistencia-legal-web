import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/utils/dimensions.dart';

class SosConductorView extends StatelessWidget {
  final bool isEmbeddedInDashboard;

  const SosConductorView({
    super.key,
    this.isEmbeddedInDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    final ConductorController controller = Get.put(ConductorController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 850;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. ENCABEZADO DE TRANQUILIDAD Y FICHA DEL CONDUCTOR
              _buildCalmHeader(context, controller, isDark, isWideScreen),

              // 2. CUERPO DINÁMICO DEL WIZARD (ANIMATED SWITCHER)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen ? 24 : 14,
                  vertical: 16,
                ),
                child: Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildWizardStep(context, controller, isDark, isWideScreen),
                  );
                }),
              ),

              // 3. ACCESO DIRECTO A BILLETERA DIGITAL (SIEMPRE DISPONIBLE AL FINAL)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isWideScreen ? 24 : 14,
                  0,
                  isWideScreen ? 24 : 14,
                  18,
                ),
                child: _buildBilleteraDigitalCompacta(context, isDark),
              ),
            ],
          ),
        );
      },
    );

    if (isEmbeddedInDashboard) {
      return content;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFEBF3FC),
      appBar: AppBar(
        title: const Text("Portal Conductor — Asistencia Legal"),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: content,
        ),
      ),
    );
  }

  // --- 1. ENCABEZADO CALMANTE CON FICHA DEL CONDUCTOR ---
  Widget _buildCalmHeader(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    bool isWide,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 22 : 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Logo/Balanza y Título
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.balance_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "LegalTech Conductor",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: isWide ? 16 : 14.5,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Ficha del Conductor simple y limpia
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_taxi_rounded, color: Color(0xFFD97706), size: 15),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${controller.nombreConductor} · ${controller.unidadTaxi} (${controller.cooperativa})",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. SWITCHER DEL WIZARD DE PASOS ---
  Widget _buildWizardStep(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    bool isWide,
  ) {
    switch (controller.pasoActual.value) {
      case 0:
        return _buildPaso1TipoIncidente(context, controller, isDark, isWide);
      case 1:
        return _buildPaso2TriageBinario(context, controller, isDark, isWide);
      case 2:
      default:
        return _buildPaso3DictamenYLlamada(context, controller, isDark, isWide);
    }
  }

  // =========================================================================
  // PASO 1: SELECCIÓN DEL TIPO DE INCIDENTE (4 BOTONES GIGANTES CON MÁXIMO COLOR)
  // =========================================================================
  Widget _buildPaso1TipoIncidente(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    bool isWide,
  ) {
    return Column(
      key: const ValueKey('paso_1_incidentes'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Indicador de Paso
        _buildStepIndicator(
          pasoActual: 1,
          totalPasos: 3,
          titulo: "¿Qué situación tienes en la vía?",
          subtitulo: "Selecciona una opción en 1 toque para activar tu defensa.",
          isDark: isDark,
        ),
        const SizedBox(height: 14),

        // Lista de 4 botones gigantes en color directo y sólido ("rojo y ya", "azul y ya")
        Column(
          children: controller.opcionesIncidentes.map((opcion) {
            final Color colorOpcion = opcion.color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.seleccionarIncidente(opcion.tipo),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 16 : 14,
                      vertical: isWide ? 16 : 14,
                    ),
                    decoration: BoxDecoration(
                      color: colorOpcion, // COLOR DIRECTO SÓLIDO
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorOpcion.withValues(alpha: 0.38),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Contenedor Emoji / Icono con sutil fondo blanco traslúcido
                        Container(
                          width: isWide ? 52 : 48,
                          height: isWide ? 52 : 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            opcion.emoji,
                            style: TextStyle(fontSize: isWide ? 26 : 24),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Título y Detalle en texto blanco de alto impacto y contraste
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                opcion.titulo,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isWide ? 17 : 15.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                opcion.descripcion,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: isWide ? 12.5 : 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.92),
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Botón circular con flecha de acción
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Tarjeta interactiva y táctil para las opciones de Triage
  Widget _buildBotonTriageCard({
    required String titulo,
    required Color color,
    required IconData icono,
    required VoidCallback onTap,
    required bool isDark,
    required bool isWide,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 18 : 14,
              vertical: isWide ? 16 : 14,
            ),
            decoration: BoxDecoration(
              color: color, // COLOR DIRECTO SÓLIDO
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.38),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icono, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: isWide ? 16 : 14.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // PASO 2: EVALUACIÓN CRÍTICA BINARIA (TRIAGE PENAL)
  // =========================================================================
  Widget _buildPaso2TriageBinario(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    bool isWide,
  ) {
    final subPaso = controller.subPasoTriage.value;
    final tipo = controller.tipoSeleccionado.value ?? TipoIncidente.meChoque;
    final bool esAgresion = (tipo == TipoIncidente.agresionProblemaPersonal);
    final bool esChocado = (tipo == TipoIncidente.meChocaron);

    return Column(
      key: ValueKey('paso_2_triage_${tipo.name}_$subPaso'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botón de Volver y Paso
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextButton.icon(
                onPressed: controller.retrocederPaso,
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: Text(
                  subPaso == 1 ? "Reevaluar víctimas" : "Cambiar incidente",
                  overflow: TextOverflow.ellipsis,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subPaso == 0 ? "PASO 2 DE 3: TRIAGE PENAL" : "PASO 2 DE 3: ESTADO DEL TAXI",
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (subPaso == 0) ...[
          // --- PREGUNTA CRÍTICA: EVALUACIÓN DE VÍCTIMAS / GRAVEDAD ---
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    esAgresion
                        ? "⚠️ EVALUACIÓN DE CONFLICTO"
                        : (esChocado ? "🚗💥 EVALUACIÓN DEL IMPACTO" : "🚨 EVALUACIÓN DE URGENCIA"),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: esAgresion ? const Color(0xFF7C3AED) : const Color(0xFFDC2626),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  esAgresion
                      ? "¿HAY AGRESIÓN FÍSICA O PERSONAS HERIDAS?"
                      : (esChocado
                          ? "¿HAY HERIDOS O ALGÚN FALLECIDO?"
                          : "¿HAY PERSONAS HERIDAS O ALGÚN FALLECIDO?"),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: isWide ? 19 : 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    height: 1.25,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                if (esAgresion) ...[
                  // Opción 1: Agresión física / heridos
                  _buildBotonTriageCard(
                    titulo: "HAY AGRESIÓN FÍSICA O HERIDOS",
                    color: const Color(0xFFDC2626),
                    icono: Icons.emergency_rounded,
                    onTap: () => controller.responderSeveridad(SeveridadVictimas.heridos),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 2: Solo discusión / altercado verbal
                  _buildBotonTriageCard(
                    titulo: "SOLO CONFLICTO VERBAL O AMENAZA",
                    color: const Color(0xFF7C3AED),
                    icono: Icons.record_voice_over_rounded,
                    onTap: () => controller.responderSeveridad(SeveridadVictimas.ninguna),
                    isDark: isDark,
                    isWide: isWide,
                  ),
                ] else ...[
                  // Opción 1: Fallecido
                  _buildBotonTriageCard(
                    titulo: "HAY PERSONA FALLECIDA",
                    color: const Color(0xFF991B1B),
                    icono: Icons.warning_rounded,
                    onTap: () => controller.responderSeveridad(SeveridadVictimas.fallecido),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 2: Heridos
                  _buildBotonTriageCard(
                    titulo: "HAY PERSONAS HERIDAS",
                    color: const Color(0xFFDC2626),
                    icono: Icons.health_and_safety_rounded,
                    onTap: () => controller.responderSeveridad(SeveridadVictimas.heridos),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 3: Solo daños
                  _buildBotonTriageCard(
                    titulo: "NO, SOLO DAÑOS / LATA",
                    color: const Color(0xFF059669),
                    icono: Icons.check_circle_outline_rounded,
                    onTap: () => controller.responderSeveridad(SeveridadVictimas.ninguna),
                    isDark: isDark,
                    isWide: isWide,
                  ),
                ],
              ],
            ),
          ),
        ] else ...[
          // --- PREGUNTA SECUNDARIA: ¿DAÑOS MATERIALES GRAVES? ---
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "🔧 EVALUACIÓN VEHICULAR",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  esChocado
                      ? "¿LOS DAÑOS IMPIDEN RODAR TU TAXI?"
                      : "¿LOS DAÑOS IMPIDEN RODAR EL TAXI?",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: isWide ? 19 : 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    height: 1.25,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Botón SÍ (Daños graves)
                _buildBotonTriageCard(
                  titulo: "SÍ, VEHÍCULO INMOVILIZADO",
                  color: const Color(0xFFEA580C),
                  icono: Icons.car_crash_rounded,
                  onTap: () => controller.responderDaniosGraves(true),
                  isDark: isDark,
                  isWide: isWide,
                ),

                // Botón NO (Daños leves)
                _buildBotonTriageCard(
                  titulo: "NO, DAÑOS LEVES O ROZADURA",
                  color: const Color(0xFF059669),
                  icono: Icons.thumb_up_alt_rounded,
                  onTap: () => controller.responderDaniosGraves(false),
                  isDark: isDark,
                  isWide: isWide,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // =========================================================================
  // PASO 3 Y 4: DICTAMEN INMEDIATO IA + LLAMADA DIRECTA AL ABOGADO
  // =========================================================================
  Widget _buildPaso3DictamenYLlamada(
    BuildContext context,
    ConductorController controller,
    bool isDark,
    bool isWide,
  ) {
    final DictamenLegal dictamen = controller.obtenerDictamenIA();
    final Color colorNivel = dictamen.colorNivel;
    final List<String> reglas = dictamen.reglas;

    return Column(
      key: const ValueKey('paso_3_dictamen_llamada'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Barra superior con botón volver y reinicio
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: controller.retrocederPaso,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text("Reevaluar"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF0284C7),
                padding: EdgeInsets.zero,
              ),
            ),
            TextButton.icon(
              onPressed: controller.reiniciarFlujo,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text("Nuevo caso"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // --- TARJETA DE DICTAMEN DE CONTENCIÓN INMEDIATA IA ---
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge de Nivel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorNivel,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(dictamen.iconoNivel, size: 14, color: Colors.white),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              dictamen.nivel,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          "Dictamen IA",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Saludo Tranquilizador y Título
              Text(
                dictamen.saludo,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colorNivel,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dictamen.titulo,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: isWide ? 17 : 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                dictamen.normativa,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white60 : Colors.grey.shade700,
                ),
              ),

              Divider(
                height: 20,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),

              // Reglas de Oro Inmediatas (Contención en sitio)
              const Text(
                "INSTRUCCIONES DE PROTECCIÓN EN EL SITIO:",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),

              ...reglas.map((regla) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.shield, size: 14, color: Color(0xFF2563EB)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          regla,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            height: 1.35,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // --- PASO 4: CONTACTO DE ASISTENCIA INMEDIATA ---
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Abogado asignado
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.nombreAbogado,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          "Abogado Especialista en Tránsito · EN GUARDIA",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Botón Prominente: LLAMAR A MI ABOGADO ASIGNADO
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    controller.iniciarLlamada();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Marcando llamada directa con ${controller.nombreAbogado} (${controller.telefonoAbogado})...",
                        ),
                        backgroundColor: const Color(0xFF059669),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 22),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "LLAMAR A MI ABOGADO ASIGNADO (${controller.telefonoAbogado})",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET INDICADOR DE PASO ---
  Widget _buildStepIndicator({
    required int pasoActual,
    required int totalPasos,
    required String titulo,
    required String subtitulo,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "PASO $pasoActual DE $totalPasos",
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalPasos, (index) {
                final isActive = index + 1 <= pasoActual;
                return Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: isActive ? 24 : 14,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF2563EB)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          titulo,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitulo,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // --- 3. BILLETERA DIGITAL COMPACTA (ACCESO DIRECTO A PAPELES EN COLOR SÓLIDO) ---
  Widget _buildBilleteraDigitalCompacta(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.folder_shared_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        "Billetera Digital",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "Licencia Tipo C · Matrícula",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            onPressed: () => _mostrarBilleteraModal(context),
            icon: const Icon(Icons.qr_code_2_rounded, size: 16),
            label: const Text(
              "Ver QR",
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modal para mostrar el documento digital con QR oficial
  void _mostrarBilleteraModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "DOCUMENTOS EN REGLA",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Credencial Digital Oficial",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Válido ante agentes de tránsito y peritos judiciales",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const _FichaDocRow(label: "Conductor:", valor: "Carlos Alberto Mendoza"),
                      Divider(height: 12, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(label: "Licencia:", valor: "Tipo C Profesional (30 Puntos)"),
                      Divider(height: 12, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(label: "Unidad / Taxi:", valor: "Unidad #42 · Coo. Los Lagos"),
                      Divider(height: 12, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(label: "Placa / RTV:", valor: "IBA-1234 · RTV 2024 Aprobada"),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFF0F172A)),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Cerrar Documento"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FichaDocRow extends StatelessWidget {
  final String label;
  final String valor;

  const _FichaDocRow({required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            valor,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
