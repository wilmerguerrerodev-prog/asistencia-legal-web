import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SosConductorView extends StatefulWidget {
  final bool isEmbeddedInDashboard;

  const SosConductorView({
    super.key,
    this.isEmbeddedInDashboard = false,
  });

  @override
  State<SosConductorView> createState() => _SosConductorViewState();
}

class _SosConductorViewState extends State<SosConductorView> {
  // Selector de tipo de consulta legal
  int selectedIncidentIndex = 1; // 1 = [Control de Tránsito] por defecto
  final List<Map<String, dynamic>> incidentTypes = [
    {
      "label": "Colisión o Choque",
      "subtitle": "Asistencia técnica y reporte vial",
      "icon": Icons.directions_car_rounded,
    },
    {
      "label": "Control de Tránsito",
      "subtitle": "Revisión documental o retención",
      "icon": Icons.fact_check_outlined,
    },
    {
      "label": "Impugnación de Citación",
      "subtitle": "Revisión de boleta o sanción",
      "icon": Icons.description_rounded,
    },
    {
      "label": "Soporte y Seguridad",
      "subtitle": "Respaldo jurídico en ruta",
      "icon": Icons.verified_user_outlined,
    },
  ];

  // Estado de evidencias
  bool hasPhoto = true;

  // Relato breve precargado
  late TextEditingController _relatoController;

  @override
  void initState() {
    super.initState();
    _relatoController = TextEditingController(
      text:
          "El agente de tránsito me pide la matrícula y dice que va a retener el taxi por llantas lisas en operativo de rutina. No hubo choque.",
    );
  }

  @override
  void dispose() {
    _relatoController.dispose();
    super.dispose();
  }

  // --- FLUJO INTELIGENTE: ENVIAR CASO Y ANALIZAR CON IA ---
  void _enviarCasoConIA() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icono con halo azul IA
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFF2563EB),
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Título
                const Text(
                  "¡Expediente Jurídico Analizado!",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "La IA Legal extrajo el marco normativo y transmitió la ficha al abogado.",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),

                // Ficha del Análisis IA
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.gavel_rounded, size: 16, color: Color(0xFF2563EB)),
                          const SizedBox(width: 6),
                          Text(
                            "Análisis Legal IA Preliminar",
                            style: ubuntuBold.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "• Causal: Control de rutina y revisión documental.\n• Normativa: Art. 390 num. 5 COIP.\n• Veredicto IA: No procede retención del vehículo sin informe pericial en el lugar.",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          height: 1.4,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Caso: #LEG-2024-001",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "Abogado asignado en línea",
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Color(0xFF047857),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Botón destacado: Conectar con el abogado ahora
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _contactarAbogadoDirecto(context);
                  },
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 18),
                  label: const Text(
                    "CONECTAR AHORA CON EL ABOGADO",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Botón secundario: Cerrar
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("Cerrar y esperar llamada"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- MODAL DE CONTACTO DIRECTO INMEDIATO ---
  void _contactarAbogadoDirecto(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    color: Color(0xFF10B981),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Contacto Directo con Abogado",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                const Text(
                  "Canal prioritario de guardia para el conductor en ruta. Conexión inmediata sin esperas.",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF0F172A),
                        child: Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. Esteban Narváez",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Especialista en Tránsito y COIP · EN LÍNEA",
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
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Llamando al abogado de turno (+593 99 123 4567)..."),
                              backgroundColor: Color(0xFF059669),
                            ),
                          );
                        },
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text("Llamar"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Abriendo canal directo de WhatsApp..."),
                              backgroundColor: Color(0xFF2563EB),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        label: const Text("WhatsApp"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text("Regresar", style: TextStyle(color: Colors.grey)),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget fullLayout = LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 850;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. ENCABEZADO SUPERIOR EXTENDIDO
              _buildWideHeader(context, isDark, isWideScreen),

              // 2. CUERPO CON DISTRIBUCIÓN RESPONSIVA
              Padding(
                padding: EdgeInsets.all(isWideScreen ? 22 : 14),
                child: isWideScreen
                    ? _buildDesktopTwoColumnLayout(context, isDark)
                    : _buildMobileSingleColumnLayout(context, isDark),
              ),
            ],
          ),
        );
      },
    );

    if (widget.isEmbeddedInDashboard) {
      return fullLayout;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Portal Conductor - Asistencia Legal"),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: fullLayout,
        ),
      ),
    );
  }

  // --- ENCABEZADO SUPERIOR EXTENDIDO ---
  Widget _buildWideHeader(BuildContext context, bool isDark, bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
      ),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Izquierda: Balanza legal + Título + GPS
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.balance_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LegalTech — Asistencia y Protección en Ruta",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.amberAccent, size: 14),
                            SizedBox(width: 4),
                            Text(
                              "GPS: Panamericana Norte y Atahualpa (Fijado en tiempo real)",
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Derecha: Ficha de Taxi + Estado En Línea
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.local_taxi_rounded, color: Colors.amber, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "Unidad #42 · Coo. Los Lagos | Carlos M.",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "EN LÍNEA",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF34D399),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.balance_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              "Asistencia Legal en Ruta",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "EN LÍNEA",
                            style: TextStyle(
                              color: Color(0xFF34D399),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.amberAccent, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "GPS: Panamericana Norte y Atahualpa",
                        style: ubuntuMedium.copyWith(color: Colors.white70, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // --- DISTRIBUCIÓN ESCRITORIO (2 COLUMNAS AMPLIAS) ---
  Widget _buildDesktopTwoColumnLayout(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLUMNA IZQUIERDA: Tipo de incidente + Relato + Billetera Digital
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionCard(
                title: "1. Motivo de la Consulta",
                subtitle: "Selecciona la situación para orientar el protocolo de asistencia",
                icon: Icons.assignment_outlined,
                iconColor: const Color(0xFF2563EB),
                isDark: isDark,
                child: _buildWideIncidentGrid(context, isDark),
              ),
              const SizedBox(height: 18),
              _buildSectionCard(
                title: "2. Descripción de los Hechos",
                subtitle: "Declaración inicial para el abogado y el marco analítico de la IA",
                icon: Icons.edit_note_rounded,
                iconColor: const Color(0xFF2563EB),
                isDark: isDark,
                child: _buildRelatoField(context, isDark),
              ),
              const SizedBox(height: 18),
              _buildBilleteraDigital(context, isDark),
            ],
          ),
        ),

        const SizedBox(width: 22),

        // COLUMNA DERECHA: Evidencias + Despacho + Botones de Acción
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionCard(
                title: "3. Documentación y Evidencias",
                subtitle: "Fotografía de la boleta, citación o lugar del hecho",
                icon: Icons.folder_shared_rounded,
                iconColor: const Color(0xFF059669),
                isDark: isDark,
                child: _buildEvidencesSection(context, isDark),
              ),
              const SizedBox(height: 18),
              _buildSectionCard(
                title: "4. Respaldo Jurídico Directo",
                subtitle: "Sincronización en tiempo real con el panel del abogado",
                icon: Icons.verified_user_rounded,
                iconColor: const Color(0xFF0F172A),
                isDark: isDark,
                child: Column(
                  children: [
                    _buildDispatchInfoCard(context, isDark),
                    const SizedBox(height: 16),
                    _buildBotonesAccion(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- DISTRIBUCIÓN MÓVIL (1 COLUMNA) ---
  Widget _buildMobileSingleColumnLayout(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTaxiInfoCard(context, isDark),
        const SizedBox(height: 14),
        _buildIncidentSelector(context, isDark),
        const SizedBox(height: 14),
        _buildEvidencesSection(context, isDark),
        const SizedBox(height: 14),
        _buildRelatoField(context, isDark),
        const SizedBox(height: 18),
        _buildBotonesAccion(context),
        const SizedBox(height: 18),
        _buildBilleteraDigital(context, isDark),
      ],
    );
  }

  // --- CONTENEDOR DE SECCIÓN ELEGANTE ---
  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // --- GRID 2x2 AMPLIO DE INCIDENTES PARA PANTALLAS GRANDES ---
  Widget _buildWideIncidentGrid(BuildContext context, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: incidentTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final item = incidentTypes[index];
        final isSelected = selectedIncidentIndex == index;

        return InkWell(
          onTap: () {
            setState(() {
              selectedIncidentIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : (isDark ? const Color(0xFF1E293B) : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : (isDark ? Colors.white12 : Colors.grey.shade300),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.15)
                        : (isDark ? Colors.white10 : const Color(0xFF2563EB).withValues(alpha: 0.08)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    size: 20,
                    color: isSelected ? Colors.white : const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["label"],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item["subtitle"],
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 10,
                          color: isSelected ? Colors.white70 : Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2563EB),
                    size: 16,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- SELECTOR TIPO CHIP (UTILIZADO EN MÓVIL) ---
  Widget _buildIncidentSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.assignment_outlined, size: 16, color: Color(0xFF2563EB)),
            const SizedBox(width: 6),
            Text(
              "Motivo de la Consulta Legal:",
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(incidentTypes.length, (index) {
            final item = incidentTypes[index];
            final isSelected = selectedIncidentIndex == index;

            return InkWell(
              onTap: () {
                setState(() {
                  selectedIncidentIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF0F172A)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item["icon"] as IconData,
                      size: 15,
                      color: isSelected ? Colors.white : const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item["label"],
                      style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // --- SECCIÓN DE EVIDENCIAS DIGITALES (FOTO DE BOLETA / LUGAR) ---
  Widget _buildEvidencesSection(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () {
        setState(() {
          hasPhoto = !hasPhoto;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasPhoto ? const Color(0xFF10B981) : Colors.grey.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hasPhoto
                    ? const Color(0xFF10B981).withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.photo_camera_rounded,
                color: hasPhoto ? const Color(0xFF10B981) : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: Text(
                          "Foto de la Boleta / Lugar",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (hasPhoto)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "ADJUNTADO",
                            style: TextStyle(
                              color: Color(0xFF047857),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasPhoto
                        ? "Foto adjuntada: Citación / Operativo (14:21:05)"
                        : "Toca para adjuntar fotografía de la boleta o citación",
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: hasPhoto ? const Color(0xFF059669) : Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasPhoto ? Icons.check_circle_rounded : Icons.add_circle_outline,
              color: hasPhoto ? const Color(0xFF10B981) : Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // --- RELATO DE LOS HECHOS ---
  Widget _buildRelatoField(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _relatoController,
          maxLines: 4,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: "¿Qué te indican los agentes o qué ocurrió en el lugar?",
            hintStyle: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.white12 : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      "Dictado por voz habilitado",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${_relatoController.text.length} caracteres",
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- FICHA DE INFORMACIÓN DE ASISTENCIA ---
  Widget _buildDispatchInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFF2563EB).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user_rounded, color: Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Asistencia Jurídica en Tiempo Real",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Al enviar la consulta, el caso se asigna al abogado de turno para orientarte.",
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTONES DE ACCIÓN: ENVIAR CON IA + CONTACTAR ABOGADO ---
  Widget _buildBotonesAccion(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryNarrow = constraints.maxWidth < 360;

        final btnEnviarIA = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 3,
            shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
          onPressed: _enviarCasoConIA,
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 17, color: Color(0xFF60A5FA)),
                SizedBox(width: 6),
                Text(
                  "ENVIAR CASO (CON IA)",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );

        final btnLlamarAbogado = OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF059669),
            backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.08),
            side: const BorderSide(color: Color(0xFF10B981), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
          onPressed: () => _contactarAbogadoDirecto(context),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_in_talk_rounded, size: 17, color: Color(0xFF059669)),
                SizedBox(width: 6),
                Text(
                  "CONTACTAR ABOGADO",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF047857),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );

        if (isVeryNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 48, child: btnEnviarIA),
              const SizedBox(height: 8),
              SizedBox(height: 48, child: btnLlamarAbogado),
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 5, child: SizedBox(height: 48, child: btnEnviarIA)),
            const SizedBox(width: 10),
            Expanded(flex: 5, child: SizedBox(height: 48, child: btnLlamarAbogado)),
          ],
        );
      },
    );
  }

  // --- BILLETERA DIGITAL (DOCUMENTOS EN REGLA) ---
  Widget _buildBilleteraDigital(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.6) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.folder_shared_outlined, size: 18, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Billetera Digital Legal",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Documentos vehiculares y credenciales al día",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 12, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      "AL DÍA",
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF047857),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildDocumentCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.badge_outlined,
                  iconColor: const Color(0xFF2563EB),
                  title: "Licencia de Conducir",
                  subtitle: "Tipo C · Profesional",
                  badge: "30 PUNTOS",
                  badgeColor: const Color(0xFF10B981),
                  detail: "Vigencia: Dic 2027",
                  onTap: () => _mostrarDocumentoModal(
                    context,
                    title: "Licencia de Conducir Profesional",
                    docType: "Tipo C - Vehículos de Transporte Comercial / Taxi",
                    emision: "15/01/2023",
                    caducidad: "14/12/2027",
                    puntos: "30 / 30 Puntos",
                    entidad: "Agencia Nacional de Tránsito (ANT)",
                    numero: "1003456789",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDocumentCard(
                  context: context,
                  isDark: isDark,
                  icon: Icons.directions_car_filled_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: "Matrícula Vehicular",
                  subtitle: "Placa: IBA-1234",
                  badge: "RTV 2024",
                  badgeColor: const Color(0xFF0284C7),
                  detail: "Hyundai Accent 2022",
                  onTap: () => _mostrarDocumentoModal(
                    context,
                    title: "Matrícula y Revisión Técnica",
                    docType: "Transporte Comercial en Taxi Convencional",
                    emision: "04/03/2024",
                    caducidad: "04/03/2025",
                    puntos: "RTV Aprobada sin observaciones",
                    entidad: "Empresa Pública de Movilidad (MOVIDELNOR)",
                    numero: "MAT-2024-99821",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required String detail,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: badgeColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.qr_code, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    detail,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDocumentoModal(
    BuildContext context, {
    required String title,
    required String docType,
    required String emision,
    required String caducidad,
    required String puntos,
    required String entidad,
    required String numero,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
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
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: Color(0xFF10B981)),
                          SizedBox(width: 4),
                          Text(
                            "DOCUMENTO VERIFICADO",
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF047857),
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
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  docType,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
                  ),
                  child: Column(
                    children: [
                      _buildDocRow("Titular:", "Carlos Alberto Mendoza"),
                      const Divider(height: 14),
                      _buildDocRow("Documento / Nro:", numero),
                      const Divider(height: 14),
                      _buildDocRow("Emitido por:", entidad),
                      const Divider(height: 14),
                      _buildDocRow("Vigencia:", "$emision hasta $caducidad"),
                      const Divider(height: 14),
                      _buildDocRow("Estado / Puntos:", puntos),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Código de verificación oficial para agentes de tránsito",
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDocRow(String label, String value) {
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
            value,
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

  // --- FICHA RÁPIDA DEL TAXI (MÓVIL) ---
  Widget _buildTaxiInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.local_taxi_rounded, color: Colors.amber, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ficha rápida del taxi",
                  style: ubuntuRegular.copyWith(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  "Unidad #42 - Cooperativa Los Lagos | Carlos M.",
                  style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.blueAccent, size: 18),
        ],
      ),
    );
  }
}
