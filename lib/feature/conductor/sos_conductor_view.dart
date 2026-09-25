import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/conductor/widgets/incidente_vector_icon.dart';
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
                    child: _buildWizardStep(
                        context, controller, isDark, isWideScreen),
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
      backgroundColor:
          isDark ? const Color(0xFF0B132B) : const Color(0xFFEBF3FC),
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
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_taxi_rounded,
                    color: Color(0xFFD97706), size: 15),
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
                const SizedBox(width: 8),
                // Indicador reactivo de GPS
                Obx(() {
                  final estado = controller.estadoGps.value;
                  Color colorPunto;
                  Color colorFondo;
                  if (estado == 'GPS activo') {
                    colorPunto = const Color(0xFF10B981);
                    colorFondo =
                        const Color(0xFF10B981).withValues(alpha: 0.12);
                  } else if (estado == 'Localizando...') {
                    colorPunto = const Color(0xFFF59E0B);
                    colorFondo =
                        const Color(0xFFF59E0B).withValues(alpha: 0.12);
                  } else {
                    colorPunto = const Color(0xFFEF4444);
                    colorFondo =
                        const Color(0xFFEF4444).withValues(alpha: 0.12);
                  }

                  return GestureDetector(
                    onTap: () {
                      controller.capturarUbicacionInicial();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Reintentando conectar con satélite GPS..."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: colorFondo,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: colorPunto,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4.5),
                          Text(
                            estado,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: colorPunto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
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
        // Indicador de Paso con saludo cercano sugerido por el abogado
        _buildStepIndicator(
          pasoActual: 1,
          totalPasos: 3,
          titulo: "¡Hola! ¿Cuál es tu problema?",
          subtitulo: "¿Cómo podemos ayudarte?",
          isDark: isDark,
        ),
        const SizedBox(height: 16),

        // 4 Botones grandes cuadrados sin mensajes inferiores (Grilla 2x2 en móvil, 4 en línea en escritorio)
        if (isWide)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildBotonIncidenteCuadrado(
                    opcion: controller.opcionesIncidentes[0],
                    onTap: () => controller.seleccionarIncidente(
                        controller.opcionesIncidentes[0].tipo),
                    isWide: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBotonIncidenteCuadrado(
                    opcion: controller.opcionesIncidentes[1],
                    onTap: () => controller.seleccionarIncidente(
                        controller.opcionesIncidentes[1].tipo),
                    isWide: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBotonIncidenteCuadrado(
                    opcion: controller.opcionesIncidentes[2],
                    onTap: () => controller.seleccionarIncidente(
                        controller.opcionesIncidentes[2].tipo),
                    isWide: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildBotonIncidenteCuadrado(
                    opcion: controller.opcionesIncidentes[3],
                    onTap: () => controller.seleccionarIncidente(
                        controller.opcionesIncidentes[3].tipo),
                    isWide: true,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildBotonIncidenteCuadrado(
                        opcion: controller.opcionesIncidentes[0],
                        onTap: () => controller.seleccionarIncidente(
                            controller.opcionesIncidentes[0].tipo),
                        isWide: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBotonIncidenteCuadrado(
                        opcion: controller.opcionesIncidentes[1],
                        onTap: () => controller.seleccionarIncidente(
                            controller.opcionesIncidentes[1].tipo),
                        isWide: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildBotonIncidenteCuadrado(
                        opcion: controller.opcionesIncidentes[2],
                        onTap: () => controller.seleccionarIncidente(
                            controller.opcionesIncidentes[2].tipo),
                        isWide: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBotonIncidenteCuadrado(
                        opcion: controller.opcionesIncidentes[3],
                        onTap: () => controller.seleccionarIncidente(
                            controller.opcionesIncidentes[3].tipo),
                        isWide: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Tarjeta interactiva táctil cuadrada grande para los incidentes del Paso 1
  Widget _buildBotonIncidenteCuadrado({
    required OpcionIncidente opcion,
    required VoidCallback onTap,
    required bool isWide,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: BoxConstraints(
            minHeight: isWide ? 172 : 156,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 14 : 10,
            vertical: isWide ? 18 : 16,
          ),
          decoration: BoxDecoration(
            color: opcion.color, // Color sólido directo
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: opcion.color.withValues(alpha: 0.38),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge cuadrado blanco grande con ilustración vectorial moderna a color
              Container(
                width: isWide ? 76 : 68,
                height: isWide ? 76 : 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: IncidenteVectorIcon(
                  tipo: opcion.tipo,
                  size: isWide ? 54 : 48,
                  useModernColors: true,
                ),
              ),
              const SizedBox(height: 12),

              // Título en blanco de alto impacto (sin texto secundario debajo)
              Text(
                opcion.titulo,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.2,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
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
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 16 : 14,
              vertical: isWide ? 16 : 14,
            ),
            decoration: BoxDecoration(
              color: color, // COLOR DIRECTO SÓLIDO
              borderRadius: BorderRadius.circular(18),
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
                // Badge blanco grande con icono moderno a color
                Container(
                  width: isWide ? 56 : 50,
                  height: isWide ? 56 : 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icono,
                      color: color,
                      size: isWide ? 32 : 28,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Título en blanco de alto impacto
                Expanded(
                  child: Text(
                    titulo,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: isWide ? 15.5 : 14.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Botón circular con flecha de acción
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
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
                subPaso == 0
                    ? "PASO 2 DE 3: TRIAGE PENAL"
                    : "PASO 2 DE 3: ESTADO DEL TAXI",
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
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                        : (esChocado
                            ? "🚗💥 EVALUACIÓN DEL IMPACTO"
                            : "🚨 EVALUACIÓN DE URGENCIA"),
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: esAgresion
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFFDC2626),
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
                    icono: Icons.front_hand_rounded,
                    onTap: () => controller
                        .responderSeveridad(SeveridadVictimas.heridos),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 2: Solo discusión / altercado verbal
                  _buildBotonTriageCard(
                    titulo: "SOLO CONFLICTO VERBAL O AMENAZA",
                    color: const Color(0xFF7C3AED),
                    icono: Icons.forum_rounded,
                    onTap: () => controller
                        .responderSeveridad(SeveridadVictimas.ninguna),
                    isDark: isDark,
                    isWide: isWide,
                  ),
                ] else ...[
                  // Opción 1: Fallecido
                  _buildBotonTriageCard(
                    titulo: "HAY PERSONA FALLECIDA",
                    color: const Color(0xFF991B1B),
                    icono: Icons.dangerous_rounded,
                    onTap: () => controller
                        .responderSeveridad(SeveridadVictimas.fallecido),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 2: Heridos
                  _buildBotonTriageCard(
                    titulo: "HAY PERSONAS HERIDAS",
                    color: const Color(0xFFDC2626),
                    icono: Icons.medical_services_rounded,
                    onTap: () => controller
                        .responderSeveridad(SeveridadVictimas.heridos),
                    isDark: isDark,
                    isWide: isWide,
                  ),

                  // Opción 3: Solo daños
                  _buildBotonTriageCard(
                    titulo: "NO, SOLO DAÑOS / LATA",
                    color: const Color(0xFF059669),
                    icono: Icons.car_repair_rounded,
                    onTap: () => controller
                        .responderSeveridad(SeveridadVictimas.ninguna),
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
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                  icono: Icons.check_circle_rounded,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorNivel,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(dictamen.iconoNivel,
                              size: 14, color: Colors.white),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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

              ...reglas.asMap().entries.map((entry) {
                final int idx = entry.key + 1;
                final String regla = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$idx",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          regla,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF334155),
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
              // Abogado asignado con badge ejecutivo grande
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.gavel_rounded,
                        color: Color(0xFF2563EB),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.nombreAbogado,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Especialista en Tránsito y COIP",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Botón Único: Contactar con abogado (Directo wa.me)
              Container(
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {
                    controller.contactarAbogadoPorWhatsApp();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Conectando con ${controller.nombreAbogado} (${controller.telefonoAbogado})...",
                        ),
                        backgroundColor: const Color(0xFF16A34A),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.phone_in_talk_rounded,
                          size: 20,
                          color: Color(0xFF25D366),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Contactar con abogado",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: 0.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1)),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Badge blanco grande con icono moderno
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.folder_shared_rounded,
                  color: Color(0xFF2563EB), size: 26),
            ),
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
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.verified,
                        size: 15, color: Color(0xFF10B981)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "Licencia Tipo C · Matrícula",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11.5,
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () => _mostrarBilleteraModal(context),
            icon: const Icon(Icons.qr_code_2_rounded, size: 18),
            label: const Text(
              "Ver QR",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w800,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const _FichaDocRow(
                          label: "Conductor:", valor: "Carlos Alberto Mendoza"),
                      Divider(
                          height: 12,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(
                          label: "Licencia:",
                          valor: "Tipo C Profesional (30 Puntos)"),
                      Divider(
                          height: 12,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(
                          label: "Unidad / Taxi:",
                          valor: "Unidad #42 · Coo. Los Lagos"),
                      Divider(
                          height: 12,
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0)),
                      const _FichaDocRow(
                          label: "Placa / RTV:",
                          valor: "IBA-1234 · RTV 2024 Aprobada"),
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
                    child: const Icon(Icons.qr_code_2_rounded,
                        size: 90, color: Color(0xFF0F172A)),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
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
