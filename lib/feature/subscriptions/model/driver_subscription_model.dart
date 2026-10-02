import 'package:flutter/material.dart';

class DriverSubscription {
  final String id;
  final String nombre;
  final String cedula;
  final String telefono;
  final String cooperativa;
  final String unidad;
  final String placa;
  bool activa;
  String estado;
  final String planId;
  final String planNombre;
  final double precio;
  DateTime fechaUltimoPago;
  DateTime fechaVencimiento;
  String metodoPago;

  DriverSubscription({
    required this.id,
    required this.nombre,
    required this.cedula,
    required this.telefono,
    required this.cooperativa,
    required this.unidad,
    required this.placa,
    this.activa = true,
    this.estado = 'Al día',
    this.planId = 'plan_mensual_1usd',
    this.planNombre = 'Cobertura Total 24/7 (\$1.00 / mes)',
    this.precio = 1.00,
    required this.fechaUltimoPago,
    required this.fechaVencimiento,
    this.metodoPago = 'Cooperativa / Descuento de Rol',
  });

  int get diasRestantes {
    final now = DateTime.now();
    return fechaVencimiento.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  bool get isVencida => !activa || diasRestantes < 0;

  bool get isPorVencer => activa && diasRestantes >= 0 && diasRestantes <= 5;

  String get estadoBadgeLabel {
    if (!activa) return 'Suspendido';
    if (diasRestantes < 0) return 'Vencido';
    if (isPorVencer) return 'Por vencer ($diasRestantes d)';
    return 'Al día';
  }

  Color get estadoBadgeColor {
    if (!activa || diasRestantes < 0) return const Color(0xFFDC2626);
    if (isPorVencer) return const Color(0xFFD97706);
    return const Color(0xFF16A34A);
  }

  Color get estadoBadgeBgColor {
    if (!activa || diasRestantes < 0) return const Color(0xFFFEF2F2);
    if (isPorVencer) return const Color(0xFFFFFBEB);
    return const Color(0xFFF0FDF4);
  }

  DriverSubscription copyWith({
    String? id,
    String? nombre,
    String? cedula,
    String? telefono,
    String? cooperativa,
    String? unidad,
    String? placa,
    bool? activa,
    String? estado,
    String? planId,
    String? planNombre,
    double? precio,
    DateTime? fechaUltimoPago,
    DateTime? fechaVencimiento,
    String? metodoPago,
  }) {
    return DriverSubscription(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      cooperativa: cooperativa ?? this.cooperativa,
      unidad: unidad ?? this.unidad,
      placa: placa ?? this.placa,
      activa: activa ?? this.activa,
      estado: estado ?? this.estado,
      planId: planId ?? this.planId,
      planNombre: planNombre ?? this.planNombre,
      precio: precio ?? this.precio,
      fechaUltimoPago: fechaUltimoPago ?? this.fechaUltimoPago,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      metodoPago: metodoPago ?? this.metodoPago,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'cedula': cedula,
      'telefono': telefono,
      'cooperativa': cooperativa,
      'unidad': unidad,
      'placa': placa,
      'suscripcion': {
        'activa': activa,
        'estado': estado,
        'planId': planId,
        'planNombre': planNombre,
        'precio': precio,
        'fechaUltimoPago': fechaUltimoPago.toIso8601String(),
        'fechaVencimiento': fechaVencimiento.toIso8601String(),
        'diasRestantes': diasRestantes,
        'metodoPago': metodoPago,
      },
    };
  }

  factory DriverSubscription.fromMap(Map<String, dynamic> map, {String? docId}) {
    final sub = (map['suscripcion'] as Map<String, dynamic>?) ?? map;
    return DriverSubscription(
      id: docId ?? map['id'] ?? '',
      nombre: map['nombre'] ?? map['name'] ?? '',
      cedula: map['cedula'] ?? '',
      telefono: map['telefono'] ?? map['phone'] ?? '',
      cooperativa: map['cooperativa'] ?? map['cooperativeName'] ?? 'Cooperativa General',
      unidad: map['unidad'] ?? map['unidadTaxi'] ?? 'Unidad #1',
      placa: map['placa'] ?? '',
      activa: sub['activa'] ?? (map['subscriptionStatus'] == 'active'),
      estado: sub['estado'] ?? (sub['activa'] == true ? 'Al día' : 'Vencido'),
      planId: sub['planId'] ?? 'plan_mensual_1usd',
      planNombre: sub['planNombre'] ?? 'Cobertura Total 24/7 (\$1.00 / mes)',
      precio: (sub['precio'] as num?)?.toDouble() ?? 1.00,
      fechaUltimoPago: sub['fechaUltimoPago'] != null
          ? DateTime.tryParse(sub['fechaUltimoPago'].toString()) ?? DateTime.now()
          : DateTime.now().subtract(const Duration(days: 15)),
      fechaVencimiento: sub['fechaVencimiento'] != null
          ? DateTime.tryParse(sub['fechaVencimiento'].toString()) ?? DateTime.now().add(const Duration(days: 15))
          : DateTime.now().add(const Duration(days: 15)),
      metodoPago: sub['metodoPago'] ?? 'Cooperativa / Descuento de Rol',
    );
  }
}
