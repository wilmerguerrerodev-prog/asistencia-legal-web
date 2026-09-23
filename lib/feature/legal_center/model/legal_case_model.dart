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
  String? abogadoAsignado;
  String? horaDespacho;
  final List<DriverEvidence> evidencias;
  List<CaseTimelineEvent> timeline;

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
    this.abogadoAsignado,
    this.horaDespacho,
    required this.evidencias,
    required this.timeline,
  });

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
