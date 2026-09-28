import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/route_helper.dart';
import '../model/mock_user.dart';

class AuthMockController extends GetxController {
  static AuthMockController get to => Get.find<AuthMockController>();

  // Perfiles predeterminados para pruebas
  static const MockUser mockItAdmin = MockUser(
    id: 'USER-IT-01',
    name: 'Ing. Admin Sistemas',
    email: 'admin.sistemas@legaltech.ec',
    role: UserRole.itAdmin,
    canton: 'Quito',
    phone: '+593 99 000 1122',
  );

  static const MockUser mockAdminLawyer = MockUser(
    id: 'USER-LAW-DIR',
    name: 'Dr. Emir Vásquez',
    email: 'emir.vasquez@legaltech.ec',
    role: UserRole.adminLawyer,
    canton: 'Ibarra',
    phone: '+593 98 776 5544',
  );

  static const MockUser mockAssociateLawyer = MockUser(
    id: 'LAWYER-001',
    name: 'Dra. Andrea Morales',
    email: 'andrea.morales@legaltech.ec',
    role: UserRole.associateLawyer,
    canton: 'Ibarra',
    phone: '+593 99 445 1200',
    isAvailable: true,
  );

  static const MockUser mockClientDriver = MockUser(
    id: 'DRIVER-042',
    name: 'Carlos Mendoza • Unidad #42',
    email: 'carlos.mendoza@loslagos.ec',
    role: UserRole.clientDriver,
    cooperativeId: 'COOP-01',
    cooperativeName: 'Coo. Los Lagos',
    canton: 'Otavalo',
    phone: '+593 99 482 1045',
  );

  // Lista de usuarios mock disponibles
  final List<MockUser> allMockUsers = [
    mockItAdmin,
    mockAdminLawyer,
    mockAssociateLawyer,
    mockClientDriver,
  ];

  // Usuario activo en sesión mock (por defecto AdminLawyer para vista ejecutiva)
  final Rx<MockUser> currentUser = Rx<MockUser>(mockAdminLawyer);

  @override
  void onInit() {
    super.onInit();
  }

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
        Get.offAllNamed(RouteHelper.lawyerWorkspaceScreen);
        break;
      case UserRole.adminLawyer:
      case UserRole.itAdmin:
        Get.offAllNamed(RouteHelper.legalCenterScreen);
        break;
    }
  }

  /// Alterna estado de guardia del abogado asociado (Disponible / Fuera de turno)
  void toggleLawyerAvailability() {
    if (!isAssociateLawyer) return;
    HapticFeedback.lightImpact();
    final newStatus = !currentUser.value.isAvailable;
    currentUser.value = currentUser.value.copyWith(isAvailable: newStatus);
    update();

    if (Get.context != null) {
      Get.snackbar(
        newStatus ? '🟢 En Guardia Activa' : '🔴 Fuera de Turno',
        newStatus
            ? 'Estás visible para despacho de siniestros viales en ${currentUser.value.canton}.'
            : 'Pausado: No recibirás nuevas alertas de siniestros directos.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: newStatus ? const Color(0xFF1B5E20) : const Color(0xFF37474F),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(14),
      );
    }
  }
}
