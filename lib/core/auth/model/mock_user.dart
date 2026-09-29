enum UserRole {
  itAdmin, // Administrador TI: Acceso total al sistema, logs técnicos, métricas, dashboards heredados y configuración global.
  adminLawyer, // Abogado Administrador: Despacho central, monitor de siniestros, mapa global, reasignación y convenios.
  associateLawyer, // Abogado Asociado: Únicamente ve sus casos asignados, su estado de guardia y expediente de su caso activo.
  clientDriver, // Cliente Conductor: Portal SOS Conductor, tracking de su abogado asignado y documentos.
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.itAdmin:
        return 'Administrador TI';
      case UserRole.adminLawyer:
        return 'Abogado Director / Despacho';
      case UserRole.associateLawyer:
        return 'Abogado Asociado en Vía';
      case UserRole.clientDriver:
        return 'Cliente Conductor SOS';
    }
  }

  String get shortBadge {
    switch (this) {
      case UserRole.itAdmin:
        return 'SuperAdmin TI';
      case UserRole.adminLawyer:
        return 'Director Legal';
      case UserRole.associateLawyer:
        return 'Abogado de Turno';
      case UserRole.clientDriver:
        return 'Conductor';
    }
  }

  String get iconEmoji {
    switch (this) {
      case UserRole.itAdmin:
        return '💻';
      case UserRole.adminLawyer:
        return '⚖️';
      case UserRole.associateLawyer:
        return '🛡️';
      case UserRole.clientDriver:
        return '🚖';
    }
  }
}

class MockUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? cooperativeId;
  final String? cooperativeName;
  final String? canton;
  final String? phone;
  final bool isAvailable;
  final bool debeCambiarClave;
  final String? cedula;
  final String? matriculaForo;
  final String? temporaryPassword;
  final String? placa;
  final String? unidadTaxi;
  final String? licencia;
  final String? foto;

  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.cooperativeId,
    this.cooperativeName,
    this.canton,
    this.phone,
    this.isAvailable = true,
    this.debeCambiarClave = false,
    this.cedula,
    this.matriculaForo,
    this.temporaryPassword,
    this.placa,
    this.unidadTaxi,
    this.licencia,
    this.foto,
  });

  MockUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? cooperativeId,
    String? cooperativeName,
    String? canton,
    String? phone,
    bool? isAvailable,
    bool? debeCambiarClave,
    String? cedula,
    String? matriculaForo,
    String? temporaryPassword,
    String? placa,
    String? unidadTaxi,
    String? licencia,
    String? foto,
  }) {
    return MockUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      cooperativeName: cooperativeName ?? this.cooperativeName,
      canton: canton ?? this.canton,
      phone: phone ?? this.phone,
      isAvailable: isAvailable ?? this.isAvailable,
      debeCambiarClave: debeCambiarClave ?? this.debeCambiarClave,
      cedula: cedula ?? this.cedula,
      matriculaForo: matriculaForo ?? this.matriculaForo,
      temporaryPassword: temporaryPassword ?? this.temporaryPassword,
      placa: placa ?? this.placa,
      unidadTaxi: unidadTaxi ?? this.unidadTaxi,
      licencia: licencia ?? this.licencia,
      foto: foto ?? this.foto,
    );
  }
}
