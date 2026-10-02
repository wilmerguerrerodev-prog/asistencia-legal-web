import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/core/services/firebase_service.dart';
import '../model/mock_user.dart';

class AuthMockController extends GetxController {
  static AuthMockController get to => Get.find<AuthMockController>();

  // Perfiles predeterminados oficiales para producción y pruebas
  static const MockUser mockItAdmin = MockUser(
    id: 'USER-IT-01',
    name: 'Ing. Dario (Admin TI)',
    email: 'admin@legaltech.ec',
    temporaryPassword: 'admin123',
    role: UserRole.itAdmin,
    canton: 'Quito',
    phone: '+593 99 000 1122',
  );

  static const MockUser mockAdminLawyer = MockUser(
    id: 'USER-LAW-DIR',
    name: 'Dr. Emir Vásquez',
    email: 'emir@legaltech.ec',
    temporaryPassword: 'emir123',
    role: UserRole.adminLawyer,
    canton: 'Ibarra',
    phone: '+593 98 776 5544',
    matriculaForo: '10-2015-442-CJ',
  );

  static const MockUser mockAssociateLawyer = MockUser(
    id: 'LAWYER-001',
    name: 'Dra. Andrea Morales',
    email: 'abogado@legaltech.ec',
    temporaryPassword: 'abogado123',
    role: UserRole.associateLawyer,
    canton: 'Ibarra',
    phone: '+593 99 445 1200',
    matriculaForo: '10-2019-118-CJ',
    isAvailable: true,
  );

  static const MockUser mockClientDriver = MockUser(
    id: 'DRIVER-042',
    name: 'Carlos Mendoza',
    email: 'conductor@legaltech.ec',
    temporaryPassword: 'conductor123',
    role: UserRole.clientDriver,
    cooperativeId: 'COOP-01',
    cooperativeName: 'Cooperativa Los Lagos',
    unidadTaxi: 'Unidad #42',
    placa: 'IBA-1234',
    cedula: '1002345678',
    licencia: 'Tipo C Profesional',
    canton: 'Otavalo',
    phone: '+593 99 482 1045',
  );

  /// Abogado con contraseña temporal para probar el flujo de primer login y cambio de clave
  static const MockUser mockTempLawyer = MockUser(
    id: 'LAWYER-TEMP-002',
    name: 'Dr. Carlos Revelo',
    email: 'carlos.revelo@legaltech.ec',
    role: UserRole.associateLawyer,
    canton: 'Ibarra',
    phone: '+593 99 778 9900',
    cedula: '1003456789',
    matriculaForo: '10-2022-315-CJ',
    temporaryPassword: 'LegalTech2026!',
    debeCambiarClave: true,
    isAvailable: true,
  );

  // Lista de usuarios mock disponibles
  final List<MockUser> allMockUsers = [
    mockItAdmin,
    mockAdminLawyer,
    mockAssociateLawyer,
    mockTempLawyer,
    mockClientDriver,
  ];

  // Lista observable de abogados registrados en la sesión actual
  final RxList<MockUser> registeredLawyers = <MockUser>[
    mockAssociateLawyer,
    mockTempLawyer,
  ].obs;

  // Usuario activo en sesión mock (por defecto AdminLawyer para vista ejecutiva)
  final Rx<MockUser> currentUser = Rx<MockUser>(mockAdminLawyer);

  MockUser get user => currentUser.value;
  UserRole get role => currentUser.value.role;

  bool get isItAdmin => role == UserRole.itAdmin;
  bool get isAdminLawyer => role == UserRole.adminLawyer;
  bool get isAssociateLawyer => role == UserRole.associateLawyer;
  bool get isClientDriver => role == UserRole.clientDriver;

  /// Cambia de rol al instante en modo prueba y redirige a la vista correspondiente
  void switchRole(UserRole newRole, {bool navigate = true}) {
    HapticFeedback.mediumImpact();
    MockUser targetUser;
    switch (newRole) {
      case UserRole.itAdmin:
        targetUser = mockItAdmin;
        break;
      case UserRole.adminLawyer:
        targetUser = mockAdminLawyer;
        break;
      case UserRole.associateLawyer:
        targetUser = mockAssociateLawyer;
        break;
      case UserRole.clientDriver:
        targetUser = mockClientDriver;
        break;
    }

    currentUser.value = targetUser;
    update();

    if (Get.context != null) {
      Get.snackbar(
        '👤 Rol Cambiado: ${newRole.displayName}',
        'Sesión activa como: ${targetUser.name}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        icon: Text(
          newRole.iconEmoji,
          style: const TextStyle(fontSize: 22),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(14),
      );
    }

    if (navigate) {
      _navigateForRole(newRole);
    }
  }

  void switchUser(MockUser newUser, {bool navigate = true}) {
    HapticFeedback.lightImpact();
    currentUser.value = newUser;
    update();
    if (navigate) {
      _navigateForRole(newUser.role);
    }
  }

  void _navigateForRole(UserRole targetRole) {
    switch (targetRole) {
      case UserRole.clientDriver:
        Get.offAllNamed(RouteHelper.sosConductorScreen);
        break;
      case UserRole.associateLawyer:
        if (currentUser.value.debeCambiarClave) {
          Get.offAllNamed(RouteHelper.changeTemporaryPasswordScreen);
        } else {
          Get.offAllNamed(RouteHelper.lawyerWorkspaceScreen);
        }
        break;
      case UserRole.adminLawyer:
      case UserRole.itAdmin:
        Get.offAllNamed(RouteHelper.legalCenterScreen);
        break;
    }
  }

  /// Método modular listo para que Darío lo enlace a Firebase
  /// Registra un nuevo abogado en el sistema y añade sus credenciales temporales
  Future<bool> onSaveLawyer({
    required String nombre,
    required String cedula,
    required String email,
    required String telefono,
    required String canton,
    required String matriculaForo,
    required String temporaryPassword,
  }) async {
    final newLawyer = MockUser(
      id: 'LAWYER-${DateTime.now().millisecondsSinceEpoch}',
      name: nombre,
      email: email,
      role: UserRole.associateLawyer,
      canton: canton,
      phone: telefono,
      cedula: cedula,
      matriculaForo: matriculaForo,
      temporaryPassword: temporaryPassword,
      debeCambiarClave: true,
      isAvailable: true,
    );

    allMockUsers.add(newLawyer);
    registeredLawyers.add(newLawyer);
    update();

    // Sincronizar en segundo plano con Firebase Auth y Firestore
    try {
      await FirebaseService().signUp(
        email: email,
        password: temporaryPassword,
        name: nombre,
        role: UserRole.associateLawyer,
        phone: telefono,
        canton: canton,
        cedula: cedula,
        matriculaForo: matriculaForo,
        debeCambiarClave: true,
      );
    } catch (e) {
      debugPrint('Firebase onSaveLawyer sync: $e');
    }

    return true;
  }

  /// Busca un usuario mock o registrado por cédula o correo
  MockUser? findUserByIdentifier(String identifier) {
    final clean = identifier.trim().toLowerCase();
    if (clean.isEmpty) return null;

    try {
      return registeredLawyers.firstWhere(
        (u) => (u.cedula != null && u.cedula!.trim() == clean) || u.email.trim().toLowerCase() == clean,
      );
    } catch (_) {}

    try {
      return allMockUsers.firstWhere(
        (u) => (u.cedula != null && u.cedula!.trim() == clean) || u.email.trim().toLowerCase() == clean,
      );
    } catch (_) {}

    return null;
  }

  /// Método modular listo para que Darío lo enlace a Firebase
  /// Actualiza la contraseña del usuario actual y retira la bandera de cambio obligatorio
  Future<bool> onChangePassword({
    required String newPassword,
  }) async {
    final updatedUser = currentUser.value.copyWith(
      debeCambiarClave: false,
      temporaryPassword: newPassword,
    );
    currentUser.value = updatedUser;

    // Actualizar en allMockUsers y registeredLawyers para que persista en memoria
    final allIdx = allMockUsers.indexWhere((u) =>
        u.id == updatedUser.id ||
        (u.cedula != null && u.cedula == updatedUser.cedula) ||
        u.email.toLowerCase() == updatedUser.email.toLowerCase());
    if (allIdx != -1) {
      allMockUsers[allIdx] = updatedUser;
    }

    final regIdx = registeredLawyers.indexWhere((u) =>
        u.id == updatedUser.id ||
        (u.cedula != null && u.cedula == updatedUser.cedula) ||
        u.email.toLowerCase() == updatedUser.email.toLowerCase());
    if (regIdx != -1) {
      registeredLawyers[regIdx] = updatedUser;
    }

    update();

    // Actualizar contraseña en Firebase Auth y Firestore
    try {
      await FirebaseService().updatePassword(
        newPassword,
        cedula: updatedUser.cedula,
        email: updatedUser.email,
      );
    } catch (e) {
      debugPrint('Firebase onChangePassword sync: $e');
    }

    return true;
  }

  /// El servicio de LegalTech opera 24/7 continuo con notificación obligatoria al Director Legal
  void toggleLawyerAvailability() {
    if (!isAssociateLawyer) return;
    HapticFeedback.lightImpact();
    final nextState = !currentUser.value.isAvailable;
    currentUser.value = currentUser.value.copyWith(isAvailable: nextState);
    update();

    if (Get.context != null) {
      Get.snackbar(
        '🟢 Servicio Continuo 24/7 Activo',
        'Estás en disponibilidad permanente en ${currentUser.value.canton}. Cualquier demora en la toma del siniestro se notifica de inmediato al Dr. Emir Vásquez.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1B5E20),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(14),
      );
    }
  }
}
