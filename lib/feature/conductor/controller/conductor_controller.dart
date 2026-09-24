import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TipoIncidente {
  meChoque,
  meChocaron,
  operativoTransito,
  agresionProblemaPersonal,
}

enum SeveridadVictimas {
  ninguna,
  heridos,
  fallecido,
}

class OpcionIncidente {
  final TipoIncidente tipo;
  final String emoji;
  final String titulo;
  final String descripcion;
  final Color color;
  final IconData icono;

  const OpcionIncidente({
    required this.tipo,
    required this.emoji,
    required this.titulo,
    required this.descripcion,
    required this.color,
    required this.icono,
  });
}

class DictamenLegal {
  final String nivel;
  final Color colorNivel;
  final IconData iconoNivel;
  final String saludo;
  final String titulo;
  final String normativa;
  final List<String> reglas;
  final String accionInmediata;

  const DictamenLegal({
    required this.nivel,
    required this.colorNivel,
    required this.iconoNivel,
    required this.saludo,
    required this.titulo,
    required this.normativa,
    required this.reglas,
    required this.accionInmediata,
  });
}

class ConductorController extends GetxController {
  // Paso del flujo (0 = Tipo Incidente, 1 = Triage Binario, 2 = Dictamen IA y Llamada)
  final RxInt pasoActual = 0.obs;

  // Selección del tipo de incidente
  final Rx<TipoIncidente?> tipoSeleccionado = Rx<TipoIncidente?>(null);

  // Sub-paso del triage:
  // 0 = ¿Estado de las personas / víctimas?
  // 1 = ¿Daños materiales graves / taxi inmovilizado?
  final RxInt subPasoTriage = 0.obs;

  // Respuestas del triage
  final Rx<SeveridadVictimas?> severidadVictimas = Rx<SeveridadVictimas?>(null);
  final Rx<bool?> hayHeridos = Rx<bool?>(null);
  final Rx<bool?> daniosGraves = Rx<bool?>(null);

  // Temporizador de escalamiento (2 minutos = 120 segundos)
  final RxInt segundosRestantes = 120.obs;
  final RxBool llamadaIniciada = false.obs;
  Timer? _timerEscalamiento;

  // Datos del conductor
  final String nombreConductor = "Carlos Mendoza";
  final String unidadTaxi = "Unidad #42";
  final String cooperativa = "Coo. Los Lagos";
  final String placaVehiculo = "IBA-1234";

  // Datos del abogado asignado
  final String nombreAbogado = "Dr. Esteban Narváez";
  final String especialidadAbogado = "Especialista en Tránsito y COIP";
  final String telefonoAbogado = "+593 99 123 4567";

  // Opciones de incidentes con alto contraste táctil fuertemente tipadas
  final List<OpcionIncidente> opcionesIncidentes = const [
    OpcionIncidente(
      tipo: TipoIncidente.meChoque,
      emoji: "💥",
      titulo: "Me choqué",
      descripcion: "Impacto frontal o contra objeto/auto",
      color: Color(0xFFEF4444),
      icono: Icons.car_crash_rounded,
    ),
    OpcionIncidente(
      tipo: TipoIncidente.meChocaron,
      emoji: "🚗💥",
      titulo: "Me chocaron",
      descripcion: "Impacto recibido por detrás o lateral",
      color: Color(0xFFF59E0B),
      icono: Icons.directions_car_rounded,
    ),
    OpcionIncidente(
      tipo: TipoIncidente.operativoTransito,
      emoji: "👮",
      titulo: "Operativo de Tránsito / Retención Ilegal",
      descripcion: "Revisión documental o intento de grúa / retención",
      color: Color(0xFF2563EB),
      icono: Icons.fact_check_outlined,
    ),
    OpcionIncidente(
      tipo: TipoIncidente.agresionProblemaPersonal,
      emoji: "⚠️",
      titulo: "Agresión / Problema personal",
      descripcion: "Conflicto o altercado en vía pública",
      color: Color(0xFF8B5CF6),
      icono: Icons.shield_outlined,
    ),
  ];

  @override
  void onClose() {
    _timerEscalamiento?.cancel();
    super.onClose();
  }

  // Paso 1: Seleccionar tipo de incidente
  void seleccionarIncidente(TipoIncidente tipo) {
    tipoSeleccionado.value = tipo;
    if (tipo == TipoIncidente.operativoTransito) {
      // En operativos no hay colisión, pasa directo al dictamen de garantías ciudadanas
      severidadVictimas.value = SeveridadVictimas.ninguna;
      hayHeridos.value = false;
      daniosGraves.value = false;
      pasoActual.value = 2;
    } else {
      subPasoTriage.value = 0;
      pasoActual.value = 1;
    }
  }

  // Paso 2 (Pregunta 1): ¿Cuál es el estado de las personas / víctimas?
  void responderSeveridad(SeveridadVictimas severidad) {
    severidadVictimas.value = severidad;
    hayHeridos.value = (severidad != SeveridadVictimas.ninguna);

    if (severidad == SeveridadVictimas.fallecido ||
        severidad == SeveridadVictimas.heridos) {
      // Causal penal crítica: se omite daños materiales y va directo al dictamen de máxima alerta penal
      daniosGraves.value = true;
      pasoActual.value = 2;
    } else if (tipoSeleccionado.value ==
        TipoIncidente.agresionProblemaPersonal) {
      // Conflicto verbal o altercado sin lesiones físicas: pasa directo al dictamen de contención
      daniosGraves.value = false;
      pasoActual.value = 2;
    } else {
      // Si no hay heridos ni víctimas mortales en colisión, se evalúa si hay daños materiales graves
      subPasoTriage.value = 1;
    }
  }

  // Método de compatibilidad hacia atrás
  void responderHeridos(bool tieneHeridos) {
    responderSeveridad(
        tieneHeridos ? SeveridadVictimas.heridos : SeveridadVictimas.ninguna);
  }

  // Paso 2 (Pregunta 2): ¿Daños materiales graves o vehículo inmovilizado?
  void responderDaniosGraves(bool tieneDaniosGraves) {
    daniosGraves.value = tieneDaniosGraves;
    pasoActual.value = 2;
  }

  // Retroceder en el Wizard
  void retrocederPaso() {
    if (pasoActual.value == 2) {
      if (tipoSeleccionado.value == TipoIncidente.operativoTransito) {
        pasoActual.value = 0;
      } else if (tipoSeleccionado.value ==
          TipoIncidente.agresionProblemaPersonal) {
        pasoActual.value = 1;
        subPasoTriage.value = 0;
      } else if (severidadVictimas.value == SeveridadVictimas.fallecido ||
          severidadVictimas.value == SeveridadVictimas.heridos) {
        pasoActual.value = 1;
        subPasoTriage.value = 0;
      } else {
        pasoActual.value = 1;
        subPasoTriage.value = 1;
      }
    } else if (pasoActual.value == 1) {
      if (subPasoTriage.value == 1) {
        subPasoTriage.value = 0;
      } else {
        pasoActual.value = 0;
      }
    }
  }

  // Reiniciar flujo
  void reiniciarFlujo() {
    _timerEscalamiento?.cancel();
    llamadaIniciada.value = false;
    segundosRestantes.value = 120;
    pasoActual.value = 0;
    subPasoTriage.value = 0;
    tipoSeleccionado.value = null;
    severidadVictimas.value = null;
    hayHeridos.value = null;
    daniosGraves.value = null;
  }

  // Simulación de llamada directa con temporizador de escalamiento
  void iniciarLlamada() {
    llamadaIniciada.value = true;
    _timerEscalamiento?.cancel();
    segundosRestantes.value = 120;
    _timerEscalamiento = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (segundosRestantes.value > 0) {
        segundosRestantes.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// Genera el enlace directo universal de WhatsApp (wa.me) con los datos del conductor y el caso
  String obtenerEnlaceWhatsApp() {
    final telefonoLimpio = telefonoAbogado.replaceAll(RegExp(r'[^0-9]'), '');
    final dictamen = obtenerDictamenIA();
    final mensaje =
        "Hola Abogado $nombreAbogado, soy $nombreConductor de la $unidadTaxi ($cooperativa, Placa $placaVehiculo). "
        "Reporto una emergencia vial: '${dictamen.titulo}'. "
        "Solicito asistencia jurídica inmediata.";
    final uri = Uri.https('wa.me', '/$telefonoLimpio', {'text': mensaje});
    return uri.toString();
  }

  /// Inicia el contacto directo por WhatsApp activando el temporizador y generando el enlace
  void contactarWhatsAppAbogado() {
    iniciarLlamada();
    final enlace = obtenerEnlaceWhatsApp();
    debugPrint("Enlace WhatsApp preparado: $enlace");
  }

  // Dictamen de contención inmediata generado por IA (diferenciado para los 4 casos)
  DictamenLegal obtenerDictamenIA() {
    final tipo = tipoSeleccionado.value ?? TipoIncidente.meChoque;
    final severidad = severidadVictimas.value ?? SeveridadVictimas.ninguna;
    final graves = daniosGraves.value ?? false;

    // =========================================================================
    // CASO 1: OPERATIVO DE TRÁNSITO O RETENCIÓN
    // =========================================================================
    if (tipo == TipoIncidente.operativoTransito) {
      return DictamenLegal(
        nivel: "GARANTÍAS Y CONTROL VIAL",
        colorNivel: const Color(0xFF2563EB),
        iconoNivel: Icons.verified_user_rounded,
        saludo: "Hola $nombreConductor ($unidadTaxi), mantén la serenidad.",
        titulo: "Procedimiento de Control Vial y Garantías",
        normativa:
            "Marco legal: Garantías ciudadanas y límites de control operativo (Art. 390 COIP).",
        reglas: const [
          "SOLICITA EL MOTIVO FORMAL: Tienes derecho a que el agente te informe de manera clara la presunta infracción cometida.",
          "RETENCIÓN VEHICULAR CONDICIONADA: No procede retención del taxi por fallas leves o llantas sin peritaje técnico en el sitio.",
          "DERECHO CONSTITUCIONAL A FILMAR: Puedes registrar en video todo el procedimiento policial como garantía de transparencia.",
          "DOCUMENTOS DIGITALES VÁLIDOS: Entrega tu licencia y matrícula digital desde la app; no permitas retención de cédula física.",
        ],
        accionInmediata:
            "Si el agente insiste en trasladar el taxi en grúa, presiona el botón y pon a tu abogado en altavoz.",
      );
    }

    // =========================================================================
    // CASO 2: AGRESIÓN O PROBLEMA PERSONAL EN VÍA PÚBLICA
    // =========================================================================
    if (tipo == TipoIncidente.agresionProblemaPersonal) {
      if (severidad == SeveridadVictimas.fallecido ||
          severidad == SeveridadVictimas.heridos) {
        return DictamenLegal(
          nivel: "ALERTA POLICIAL — AGRESIÓN FÍSICA GRAVE",
          colorNivel: const Color(0xFF991B1B),
          iconoNivel: Icons.emergency_rounded,
          saludo:
              "Hola $nombreConductor ($unidadTaxi), tu integridad es prioridad.",
          titulo: "Agresión Física con Lesiones o Peligro Inminente",
          normativa:
              "Marco legal: Delito de lesiones flagrantes y legítima defensa (Art. 33 y 152 COIP).",
          reglas: const [
            "SOLICITA AUXILIO AL 911: Pide patrullero policial urgente y ambulancia informando tu ubicación satelital fija.",
            "PERMANECE EN LUGAR SEGURO: Bloquea seguros y sube vidrios; si hay riesgo de linchamiento, avanza a la UPC más próxima.",
            "NO UTILICES ARMAS IMPROVISADAS: El uso de palos o metales puede invertir tu figura legal de víctima a agresor penal.",
            "REGISTRA AL AGRESOR: Conserva audios, fotos o datos del agresor para la formulación inmediata de cargos en Fiscalía.",
          ],
          accionInmediata:
              "Tu abogado asignado intervendrá de inmediato para coordinar la captura en flagrancia y la denuncia.",
        );
      }

      return DictamenLegal(
        nivel: "PROTECCIÓN Y CONTENCIÓN PERSONAL",
        colorNivel: const Color(0xFF7C3AED),
        iconoNivel: Icons.shield_rounded,
        saludo: "Hola $nombreConductor ($unidadTaxi), mantén la calma.",
        titulo: "Altercado Verbal o Conflicto con Pasajero / Tercero",
        normativa:
            "Marco legal: Contravenciones de cuarta clase y resolución pacífica en vía pública.",
        reglas: const [
          "PERMANECE EN EL INTERIOR DEL TAXI: Bloquea los seguros y mantén la serenidad para evitar que el conflicto escale.",
          "NO RESPONDAS INSULTOS: Mantener la calma te posiciona jurídicamente como la parte agraviada en el parte.",
          "REGISTRA AUDIO DE LA CONVERSACIÓN: El audio ambiental sirve como prueba admisible de carreras impagas o amenazas.",
          "TRASLADO A LA UPC: Si el pasajero se niega a pagar o se torna amenazante, traslada la unidad a la UPC más cercana.",
        ],
        accionInmediata:
            "Presiona el botón para que el abogado dialogue en altavoz con el usuario y respalde tu cobro legal.",
      );
    }

    // =========================================================================
    // CASO 3: ME CHOQUÉ (EL CONDUCTOR IMPACTÓ A OTRO VEHÍCULO O PEATÓN)
    // =========================================================================
    if (tipo == TipoIncidente.meChoque) {
      if (severidad == SeveridadVictimas.fallecido) {
        return DictamenLegal(
          nivel: "ALERTA PENAL MÁXIMA — HOMICIDIO CULPOSO",
          colorNivel: const Color(0xFF991B1B),
          iconoNivel: Icons.warning_rounded,
          saludo: "$nombreConductor, MANTÉN LA CALMA Y SIGUE ESTE PROTOCOLO.",
          titulo: "Accidente de Tránsito con Persona Fallecida",
          normativa:
              "Marco legal: Procedimiento en presunto Homicidio Culposo (Art. 377 COIP) y Flagrancia.",
          reglas: const [
            "DERECHO CONSTITUCIONAL AL SILENCIO: No admitas culpas verbales ni digas 'fue mi culpa'. Cualquier dicho será usado en tu contra.",
            "PRESERVA TU INTEGRIDAD FÍSICA: Si existe peligro de linchamiento por terceros, dirígete de inmediato a la UPC más cercana.",
            "NO MUEVAS EL VEHÍCULO: La posición final del taxi y huellas de frenado son la prueba pericial clave del SIAT.",
            "NO FIRMES NINGÚN DOCUMENTO: No firmes partes ni actas sin la presencia y autorización de tu abogado defensor.",
          ],
          accionInmediata:
              "ALERTA CRÍTICA: Tu abogado penalista está asignado con prioridad urgente. Presiona llamar inmediatamente.",
        );
      }

      if (severidad == SeveridadVictimas.heridos) {
        return DictamenLegal(
          nivel: "ALERTA PENAL PRIORITARIA — LESIONES",
          colorNivel: const Color(0xFFDC2626),
          iconoNivel: Icons.health_and_safety_rounded,
          saludo: "Hola $nombreConductor ($unidadTaxi), mantén la calma.",
          titulo:
              "Accidente con Víctimas Heridas (Presunto Delito de Lesiones)",
          normativa:
              "Marco legal: Delito de tránsito con lesiones (Art. 379 y 380 COIP) y auxilio obligatorio.",
          reglas: const [
            "SOLICITA AMBULANCIA AL 911 INMEDIATAMENTE: Brindar o gestionar auxilio es un deber legal obligatorio.",
            "GUARDA SILENCIO SOBRE RESPONSABILIDADES: Permite que los paramédicos atiendan sin declarar sobre culpas ante testigos.",
            "ACTIVACIÓN DEL SPPAT / SOAT: Los gastos de salud de los heridos están cubiertos legalmente por el fondo vial.",
            "NO FIRMES ACUERDOS EN EL SITIO: No aceptes transacciones económicas hasta que exista informe médico de días de incapacidad.",
          ],
          accionInmediata:
              "Comunícate ahora con tu abogado para estructurar la defensa previa a la llegada del perito.",
        );
      }

      if (graves) {
        return DictamenLegal(
          nivel: "CONTENCIÓN DE DAÑOS MATERIALES",
          colorNivel: const Color(0xFFEA580C),
          iconoNivel: Icons.car_crash_rounded,
          saludo: "Hola $nombreConductor ($unidadTaxi), respira con calma.",
          titulo: "Colisión con Daños Importantes (Sin Víctimas)",
          normativa:
              "Marco legal: Accidente con solo daños materiales (Art. 380 COIP) — Sin Flagrancia Penal.",
          reglas: const [
            "NO EXISTE FLAGRANCIA PENAL: Al no haber heridos ni fallecidos, la ley prohíbe la detención de tu persona.",
            "TOMA FOTOGRAFÍAS PANORÁMICAS: Registra daños de ambos autos, placas, señalética y huellas antes de que muevan los autos.",
            "NO ENTREGUES DINERO EN EFECTIVO: No hagas acuerdos económicos apresurados; deben ser supervisados por tu abogado.",
            "PARTE POLICIAL O CONCILIACIÓN: Si el tercero exige cifras desmedidas, esperen el avalúo pericial oficial.",
          ],
          accionInmediata:
              "Tu abogado te guiará en la negociación o en el peritaje técnico vehicular.",
        );
      }

      // Me choqué pero daños leves
      return DictamenLegal(
        nivel: "CONCILIACIÓN RÁPIDA EN SITIO",
        colorNivel: const Color(0xFF059669),
        iconoNivel: Icons.check_circle_rounded,
        saludo: "Hola $nombreConductor ($unidadTaxi), todo tiene solución.",
        titulo: "Roce Menor o Colisión Leve Conciliable",
        normativa:
            "Marco legal: Conciliación directa entre conductores y despeje de calzada.",
        reglas: const [
          "DESPEJE DE VÍA: Si ambos autos ruedan, tomen fotos y oríllense para evitar multas por obstaculizar el tráfico.",
          "FOTOS DE DOCUMENTOS: Fotografía la matrícula y licencia de conducir del otro conductor.",
          "ACTA DE DESISTIMIENTO: Si llegan a un acuerdo de pago, debe quedar constancia firmada de mutuo acuerdo.",
          "ASESORÍA TELEFÓNICA: Pon al abogado en altavoz para que valide que el acuerdo sea legal y definitivo.",
        ],
        accionInmediata:
            "Presiona el botón de llamada para que el abogado asesore el acuerdo en tiempo real.",
      );
    }

    // =========================================================================
    // CASO 4: ME CHOCARON (EL TAXISTA ES LA PARTE AFECTADA / VÍCTIMA)
    // =========================================================================
    if (severidad == SeveridadVictimas.fallecido) {
      return DictamenLegal(
        nivel: "ALERTA PENAL — CONDUCTOR IMPACTADO / AFECTADO",
        colorNivel: const Color(0xFF991B1B),
        iconoNivel: Icons.warning_rounded,
        saludo: "$nombreConductor, MANTÉN LA CALMA: TÚ FUISTE EL IMPACTADO.",
        titulo: "Impacto Recibido con Persona Fallecida",
        normativa:
            "Marco legal: Protección de la parte afectada en siniestro con víctima mortal (Art. 377 COIP).",
        reglas: const [
          "DEJA CLARO TU ROL DE AFECTADO: Notifica de inmediato al agente que tú fuiste embestido por el otro vehículo.",
          "EXIGE RETENCIÓN DEL CAUSANTE: Asegúrate de que la policía retenga al conductor que causó el impacto.",
          "PRESERVA LA POSICIÓN DEL IMPACTO: El punto de impacto en tu taxi demuestra pericialmente que fuiste chocado.",
          "NO ASUMAS CULPAS AJENAS: No firmes ningún acta que sugiera culpabilidad compartida.",
        ],
        accionInmediata:
            "Tu abogado penalista intervendrá de inmediato para evitar cualquier imputación errónea en Fiscalía.",
      );
    }

    if (severidad == SeveridadVictimas.heridos) {
      return DictamenLegal(
        nivel: "VÍCTIMA AFECTADA — AUXILIO Y RECLAMO DE DAÑOS",
        colorNivel: const Color(0xFFDC2626),
        iconoNivel: Icons.health_and_safety_rounded,
        saludo: "Hola $nombreConductor ($unidadTaxi), mantén la calma.",
        titulo: "Fuiste Chocado y Hay Personas Heridas",
        normativa:
            "Marco legal: Cobertura médica SPPAT y reclamo de indemnización contra causante.",
        reglas: const [
          "PRIORIZA ATENCIÓN AL 911: Solicita ambulancia para tus pasajeros o para ti si resultaste herido.",
          "SPPAT DEL CAUSANTE: La cobertura médica de urgencia debe activarse con el seguro del vehículo que te impactó.",
          "IDENTIFICA AL CAUSANTE: Anota placa, modelo y datos del conductor antes de que intente retirarse del sitio.",
          "RECLAMO FORMAL: El abogado formulará la acusación particular para el pago de todas las curaciones y daños del taxi.",
        ],
        accionInmediata:
            "Llama a tu abogado para que supervise que el parte policial señale al verdadero causante.",
      );
    }

    if (graves) {
      return DictamenLegal(
        nivel: "EXIGENCIA DE INDEMNIZACIÓN Y LUCRO CESANTE",
        colorNivel: const Color(0xFF0284C7),
        iconoNivel: Icons.car_crash_rounded,
        saludo: "Hola $nombreConductor ($unidadTaxi), estamos de tu lado.",
        titulo: "Taxi Inmovilizado por Impacto de Tercero",
        normativa:
            "Marco legal: Reparación integral de daños y Lucro Cesante por días no laborados.",
        reglas: const [
          "EL QUE IMPACTA POR ALCANCE PAGA: Quien choca por detrás o invade carril debe responder por el 100% de los daños.",
          "EXIGE EL LUCRO CESANTE: Tienes derecho legal al pago del taller más el valor diario de tu carrera mientras el taxi no ruede.",
          "FOTOGRAFÍA AL OTRO CONDUCTOR: Foto de su matrícula, licencia y aseguradora. No permitas que se retire sin garantía.",
          "NO ACEPTES VALORES MÍNIMOS: El abogado calculará el valor real del daño para que no salgas perdiendo dinero.",
        ],
        accionInmediata:
            "Comunícate con tu abogado para que exija formalmente la indemnización al conductor o a su seguro.",
      );
    }

    // Me chocaron pero daños leves
    return DictamenLegal(
      nivel: "COBRO INMEDIATO DE DAÑOS LEVES",
      colorNivel: const Color(0xFF059669),
      iconoNivel: Icons.verified_rounded,
      saludo: "Hola $nombreConductor ($unidadTaxi), tú tienes la razón legal.",
      titulo: "Roce o Impacto Menor Recibido de Tercero",
      normativa:
          "Marco legal: Arreglo económico voluntario en el sitio por daños materiales.",
      reglas: const [
        "FOTOS DE EVIDENCIA: Toma fotos claras de cómo quedó el auto del tercero pegado al tuyo antes de moverlo.",
        "ACUERDO ECONÓMICO DIRECTO: El causante debe transferirte o cubrir el valor del pulido/latonería en el sitio.",
        "RECIBO O CONSTANCIA: Al recibir el valor pactado, se suscribe un desistimiento simple por el roce menor.",
        "ABOGADO EN ALTAVOZ: Si el causante se pone renuente a pagar, pon al abogado en altavoz para que le explique la ley.",
      ],
      accionInmediata:
          "Llama a tu abogado para que fije el valor justo del daño y convenza al tercero de pagar de inmediato.",
    );
  }
}
