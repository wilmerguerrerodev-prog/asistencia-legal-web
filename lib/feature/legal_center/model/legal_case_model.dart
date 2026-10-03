import 'package:flutter/material.dart';

enum UrgencyLevel {
  alta,
  media,
  baja,
}

enum CaseStatus {
  pendiente,
  dictamenAprobado,
  abogadoDespachado,
  atendido,
}

enum AlertaNivel {
  critico, // 🔴 Rojo
  regular, // 🟡 Amarillo
  menor,   // 🔵 Azul
}

extension AlertaNivelExtension on AlertaNivel {
  String get label {
    switch (this) {
      case AlertaNivel.critico:
        return 'Código Rojo';
      case AlertaNivel.regular:
        return 'Choque Regular';
      case AlertaNivel.menor:
        return 'Asist. Menor';
    }
  }

  Color get color {
    switch (this) {
      case AlertaNivel.critico:
        return const Color(0xFFD32F2F);
      case AlertaNivel.regular:
        return const Color(0xFFF57C00);
      case AlertaNivel.menor:
        return const Color(0xFF1976D2);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AlertaNivel.critico:
        return const Color(0xFFFFEBEE);
      case AlertaNivel.regular:
        return const Color(0xFFFFF3E0);
      case AlertaNivel.menor:
        return const Color(0xFFE3F2FD);
    }
  }

  IconData get icon {
    switch (this) {
      case AlertaNivel.critico:
        return Icons.emergency_rounded;
      case AlertaNivel.regular:
        return Icons.car_crash_rounded;
      case AlertaNivel.menor:
        return Icons.info_outline_rounded;
    }
  }
}

/// 4 Categorías oficiales de alerta solicitadas por el Dr. Emir Vásquez:
/// 1. Agresión física
/// 2. Tránsito / Choque
/// 3. Daños materiales
/// 4. "Otro problema" (civiles, laborales, despidos intempestivos, etc.)
enum TipoAlertaCaso {
  agresionFisica,
  transitoChoque,
  danosMateriales,
  otroProblema,
}

extension TipoAlertaCasoExtension on TipoAlertaCaso {
  String get label {
    switch (this) {
      case TipoAlertaCaso.agresionFisica:
        return 'Agresión Física';
      case TipoAlertaCaso.transitoChoque:
        return 'Tránsito / Choque';
      case TipoAlertaCaso.danosMateriales:
        return 'Daños Materiales';
      case TipoAlertaCaso.otroProblema:
        return 'Otro Problema';
    }
  }

  String get badgeLabel {
    switch (this) {
      case TipoAlertaCaso.agresionFisica:
        return '🔴 Agresión Física';
      case TipoAlertaCaso.transitoChoque:
        return '🟠 Tránsito / Choque';
      case TipoAlertaCaso.danosMateriales:
        return '🟡 Daños Materiales';
      case TipoAlertaCaso.otroProblema:
        return '🟣 Otro Problema';
    }
  }

  Color get color {
    switch (this) {
      case TipoAlertaCaso.agresionFisica:
        return const Color(0xFFD32F2F);
      case TipoAlertaCaso.transitoChoque:
        return const Color(0xFFE65100);
      case TipoAlertaCaso.danosMateriales:
        return const Color(0xFFF57C00);
      case TipoAlertaCaso.otroProblema:
        return const Color(0xFF7C3AED);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case TipoAlertaCaso.agresionFisica:
        return const Color(0xFFFFEBEE);
      case TipoAlertaCaso.transitoChoque:
        return const Color(0xFFFFF3E0);
      case TipoAlertaCaso.danosMateriales:
        return const Color(0xFFFEF3C7);
      case TipoAlertaCaso.otroProblema:
        return const Color(0xFFF3E8FF);
    }
  }

  IconData get icon {
    switch (this) {
      case TipoAlertaCaso.agresionFisica:
        return Icons.front_hand_rounded;
      case TipoAlertaCaso.transitoChoque:
        return Icons.car_crash_rounded;
      case TipoAlertaCaso.danosMateriales:
        return Icons.minor_crash_rounded;
      case TipoAlertaCaso.otroProblema:
        return Icons.gavel_rounded;
    }
  }
}

enum LawyerGuardStatus {
  enLinea,
  enAudiencia,
  noDisponible,
  noAsociado,
}

class TerritoryLawyer {
  final String id;
  final String nombre;
  final String canton;
  final String provincia;
  final String telefono;
  final String unidadMovil;
  LawyerGuardStatus estadoGuardia;
  final int casosRecibidos;
  final int casosAtendidosATiempo;
  final int tiempoPromedioRespuestaMin;
  final String especialidad;
  final String fotoUrl;
  final double lat;
  final double lng;
  int casosActivos;

  TerritoryLawyer({
    required this.id,
    required this.nombre,
    required this.canton,
    required this.provincia,
    required this.telefono,
    required this.unidadMovil,
    required this.estadoGuardia,
    required this.casosRecibidos,
    required this.casosAtendidosATiempo,
    this.tiempoPromedioRespuestaMin = 10,
    required this.especialidad,
    this.fotoUrl = '',
    this.lat = 0.2338,
    this.lng = -78.2612,
    this.casosActivos = 0,
  });

  int get porcentajeCumplimiento =>
      casosRecibidos == 0 ? 100 : ((casosAtendidosATiempo / casosRecibidos) * 100).round();

  String get estadoLabel {
    switch (estadoGuardia) {
      case LawyerGuardStatus.enLinea:
        return 'En línea';
      case LawyerGuardStatus.enAudiencia:
        return 'En audiencia';
      case LawyerGuardStatus.noDisponible:
        return 'No disponible';
      case LawyerGuardStatus.noAsociado:
        return 'Ya no asociado';
    }
  }

  Color get estadoColor {
    switch (estadoGuardia) {
      case LawyerGuardStatus.enLinea:
        return const Color(0xFF2E7D32);
      case LawyerGuardStatus.enAudiencia:
        return const Color(0xFFF57C00);
      case LawyerGuardStatus.noDisponible:
        return const Color(0xFFD32F2F);
      case LawyerGuardStatus.noAsociado:
        return const Color(0xFF546E7A);
    }
  }

  Color get estadoBgColor {
    switch (estadoGuardia) {
      case LawyerGuardStatus.enLinea:
        return const Color(0xFFE8F5E9);
      case LawyerGuardStatus.enAudiencia:
        return const Color(0xFFFFF3E0);
      case LawyerGuardStatus.noDisponible:
        return const Color(0xFFFFEBEE);
      case LawyerGuardStatus.noAsociado:
        return const Color(0xFFECEFF1);
    }
  }
}

class CaseTimelineEvent {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  CaseTimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class DriverEvidence {
  final String type; // 'audio', 'photo', 'doc'
  final String title;
  final String detail;
  final IconData icon;

  DriverEvidence({
    required this.type,
    required this.title,
    required this.detail,
    required this.icon,
  });
}

class LegalCase {
  final String id;
  final String taxistaNombre;
  final String taxistaCedula;
  final String taxistaTelefono;
  final String cooperativa;
  final String unidad;
  final String placa;
  final String vehiculoModelo;
  final String estadoSeguro;
  final String tipoIncidente;
  UrgencyLevel urgencia;
  CaseStatus estado;
  final String ubicacionDireccion;
  final double lat;
  final double lng;
  final String horaReporte;
  final String relatoConductor;
  final String articuloCoip;
  final String dictamenIaRecomendacion;
  final String dictamenIaCorto;
  final String provincia;
  final String canton;
  final bool tieneHeridosORetencion;
  AlertaNivel? _alertaNivel;
  TipoAlertaCaso? _tipoAlertaCaso;
  final String? descripcionOtroProblema;
  bool esPruebaGratuita;
  int consultasGratuitasRestantes;
  int consultasGratuitasTotales;
  bool esPlanVip;
  String? despachoCorporativo;
  String? abogadoAsignado;
  String? assignedLawyerId;
  String? horaDespacho;
  bool fueAsignadoAutomaticamente;
  double? distanciaAbogadoKm;
  String? motivoAsignacion;
  final List<DriverEvidence> evidencias;
  List<CaseTimelineEvent> timeline;

  // Datos de Suscripción / Membresía LegalTech
  bool suscripcionActiva;
  String suscripcionEstado;
  String suscripcionPlan;
  bool asistenciaCondicionadaAutorizada;

  LegalCase({
    required this.id,
    required this.taxistaNombre,
    required this.taxistaCedula,
    required this.taxistaTelefono,
    required this.cooperativa,
    required this.unidad,
    required this.placa,
    required this.vehiculoModelo,
    required this.estadoSeguro,
    required this.tipoIncidente,
    required this.urgencia,
    required this.estado,
    required this.ubicacionDireccion,
    required this.lat,
    required this.lng,
    required this.horaReporte,
    required this.relatoConductor,
    required this.articuloCoip,
    required this.dictamenIaRecomendacion,
    this.dictamenIaCorto = '',
    this.provincia = 'Imbabura',
    this.canton = 'Ibarra',
    this.tieneHeridosORetencion = false,
    AlertaNivel? alertaNivel,
    TipoAlertaCaso? tipoAlertaCaso,
    this.descripcionOtroProblema,
    this.esPruebaGratuita = false,
    this.consultasGratuitasRestantes = 10,
    this.consultasGratuitasTotales = 10,
    this.esPlanVip = true,
    this.despachoCorporativo,
    this.abogadoAsignado,
    this.assignedLawyerId,
    this.horaDespacho,
    this.fueAsignadoAutomaticamente = false,
    this.distanciaAbogadoKm,
    this.motivoAsignacion,
    required this.evidencias,
    required this.timeline,
    this.suscripcionActiva = true,
    this.suscripcionEstado = 'Activo y Protegido',
    this.suscripcionPlan = 'Cobertura Total 24/7 (\$1.00 / mes)',
    this.asistenciaCondicionadaAutorizada = false,
  })  : _alertaNivel = alertaNivel,
        _tipoAlertaCaso = tipoAlertaCaso;

  bool get isMembresiaActiva => suscripcionActiva || asistenciaCondicionadaAutorizada;

  TipoAlertaCaso get tipoAlerta {
    if (_tipoAlertaCaso != null) return _tipoAlertaCaso!;
    final t = tipoIncidente.toLowerCase();
    if (t.contains('otro') ||
        t.contains('laboral') ||
        t.contains('despido') ||
        t.contains('civil') ||
        t.contains('consulta')) {
      return TipoAlertaCaso.otroProblema;
    }
    if (t.contains('agres') ||
        t.contains('físic') ||
        t.contains('fisic') ||
        t.contains('fuga')) {
      return TipoAlertaCaso.agresionFisica;
    }
    if (t.contains('choque') ||
        t.contains('colisi') ||
        t.contains('alcance') ||
        t.contains('herido')) {
      return TipoAlertaCaso.transitoChoque;
    }
    if (t.contains('daño') ||
        t.contains('roce') ||
        t.contains('retrovisor') ||
        t.contains('semáforo') ||
        t.contains('material')) {
      return TipoAlertaCaso.danosMateriales;
    }
    return TipoAlertaCaso.transitoChoque;
  }

  set tipoAlerta(TipoAlertaCaso val) {
    _tipoAlertaCaso = val;
  }

  bool get isOtroProblema => tipoAlerta == TipoAlertaCaso.otroProblema;
  bool get isAgresionFisica => tipoAlerta == TipoAlertaCaso.agresionFisica;
  bool get isTransitoChoque => tipoAlerta == TipoAlertaCaso.transitoChoque;
  bool get isDanosMateriales => tipoAlerta == TipoAlertaCaso.danosMateriales;

  String get descripcionDetalladaCliente {
    if (descripcionOtroProblema != null && descripcionOtroProblema!.trim().isNotEmpty) {
      return descripcionOtroProblema!;
    }
    return relatoConductor;
  }

  String get planDetalleLabel {
    if (esPruebaGratuita) {
      return 'Prueba Gratuita ($consultasGratuitasRestantes/$consultasGratuitasTotales consultas)';
    }
    if (esPlanVip || isMembresiaActiva) {
      return 'Plan VIP / Cobertura Total 24/7';
    }
    return 'Membresía Vencida';
  }

  AlertaNivel get alertaNivel {
    if (_alertaNivel != null) return _alertaNivel!;
    if (urgencia == UrgencyLevel.alta || tieneHeridosORetencion) {
      return AlertaNivel.critico;
    } else if (urgencia == UrgencyLevel.media) {
      return AlertaNivel.regular;
    }
    return AlertaNivel.menor;
  }

  set alertaNivel(AlertaNivel val) {
    _alertaNivel = val;
  }

  String get shortDictamenSummary {
    if (dictamenIaCorto.isNotEmpty) return dictamenIaCorto;
    if (dictamenIaRecomendacion.isNotEmpty) {
      final firstLine = dictamenIaRecomendacion.split('\n').first;
      return firstLine.length > 90 ? '${firstLine.substring(0, 90)}...' : firstLine;
    }
    return 'Diagnóstico preliminar en proceso por motor IA LegalTech.';
  }

  String get estadoLabel {
    switch (estado) {
      case CaseStatus.pendiente:
        return 'Pendiente de Atención';
      case CaseStatus.dictamenAprobado:
        return 'Dictamen Aprobado';
      case CaseStatus.abogadoDespachado:
        return 'Abogado en Camino';
      case CaseStatus.atendido:
        return 'Caso Resuelto';
    }
  }

  Color get estadoColor {
    switch (estado) {
      case CaseStatus.pendiente:
        return const Color(0xFFE53935); // Rojo Alerta
      case CaseStatus.dictamenAprobado:
        return const Color(0xFF2E7D32); // Verde Aprobado
      case CaseStatus.abogadoDespachado:
        return const Color(0xFF1565C0); // Azul Despachado
      case CaseStatus.atendido:
        return const Color(0xFF546E7A); // Gris Concluido
    }
  }

  String get urgenciaLabel {
    switch (urgencia) {
      case UrgencyLevel.alta:
        return 'Urgencia Alta';
      case UrgencyLevel.media:
        return 'Urgencia Media';
      case UrgencyLevel.baja:
        return 'Urgencia Baja';
    }
  }

  Color get urgenciaColor {
    switch (urgencia) {
      case UrgencyLevel.alta:
        return const Color(0xFFD32F2F);
      case UrgencyLevel.media:
        return const Color(0xFFF57C00);
      case UrgencyLevel.baja:
        return const Color(0xFF388E3C);
    }
  }
}
