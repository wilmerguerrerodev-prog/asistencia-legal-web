import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/view/legal_center_screen.dart';
import 'package:getdash/feature/legal_center/widgets/legal_mobile_nav_header.dart';
import 'package:getdash/feature/menu/model/menu_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RBAC - Mock Auth & Roles Test Suite', () {
    late AuthMockController authController;
    late LegalCenterController legalController;

    setUp(() {
      Get.reset();
      authController = Get.put<AuthMockController>(AuthMockController());
      legalController = Get.put<LegalCenterController>(LegalCenterController());
    });

    test('UserRole enum metadata and badges', () {
      expect(UserRole.itAdmin.displayName, 'Administrador TI');
      expect(UserRole.itAdmin.shortBadge, 'SuperAdmin TI');
      expect(UserRole.itAdmin.iconEmoji, '💻');

      expect(UserRole.adminLawyer.displayName, 'Abogado Director / Despacho');
      expect(UserRole.adminLawyer.shortBadge, 'Director Legal');
      expect(UserRole.adminLawyer.iconEmoji, '⚖️');

      expect(UserRole.associateLawyer.displayName, 'Abogado Asociado en Vía');
      expect(UserRole.associateLawyer.shortBadge, 'Abogado de Turno');
      expect(UserRole.associateLawyer.iconEmoji, '🛡️');

      expect(UserRole.clientDriver.displayName, 'Cliente Conductor SOS');
      expect(UserRole.clientDriver.shortBadge, 'Conductor');
      expect(UserRole.clientDriver.iconEmoji, '🚖');
    });

    test('AuthMockController defaults to adminLawyer or allows associateLawyer switch', () {
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      expect(authController.role, UserRole.associateLawyer);
      expect(authController.user.id, 'LAWYER-001');
      expect(authController.user.name, 'Dra. Andrea Morales');
      expect(authController.isAssociateLawyer, isTrue);
      expect(authController.isAdminLawyer, isFalse);
      expect(authController.isItAdmin, isFalse);
      expect(authController.isClientDriver, isFalse);
    });

    test('AuthMockController switchRole navigates through all 4 roles correctly', () {
      // 1. Switch to itAdmin
      authController.switchRole(UserRole.itAdmin, navigate: false);
      expect(authController.role, UserRole.itAdmin);
      expect(authController.user.id, 'USER-IT-01');
      expect(authController.isItAdmin, isTrue);

      // 2. Switch to adminLawyer
      authController.switchRole(UserRole.adminLawyer, navigate: false);
      expect(authController.role, UserRole.adminLawyer);
      expect(authController.user.id, 'USER-LAW-DIR');
      expect(authController.user.name, 'Dr. Emir Vásquez');
      expect(authController.isAdminLawyer, isTrue);

      // 3. Switch to clientDriver
      authController.switchRole(UserRole.clientDriver, navigate: false);
      expect(authController.role, UserRole.clientDriver);
      expect(authController.user.id, 'DRIVER-042');
      expect(authController.isClientDriver, isTrue);

      // 4. Switch back to associateLawyer
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      expect(authController.role, UserRole.associateLawyer);
      expect(authController.user.id, 'LAWYER-001');
    });

    test('Lawyer availability toggle updates state correctly', () {
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      expect(authController.user.isAvailable, isTrue);
      authController.toggleLawyerAvailability();
      expect(authController.user.isAvailable, isFalse);
      authController.toggleLawyerAvailability();
      expect(authController.user.isAvailable, isTrue);
    });

    test('LegalCenterController filters cases for assigned associate lawyer (LAWYER-001)', () {
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      final myCases = legalController.myAssignedCases;
      
      expect(myCases.isNotEmpty, isTrue);
      for (final c in myCases) {
        expect(c.assignedLawyerId, 'LAWYER-001');
      }

      final activeCase = legalController.myActiveAssignedCase;
      expect(activeCase, isNotNull);
      expect(activeCase?.id, '#CASO-1041');
      expect(activeCase?.cooperativa, 'Flota Imbabura');
    });

    test('Menu items are strictly filtered according to RBAC matrix', () {
      // 1. associateLawyer: sees Mi Despacho, Dictámenes & Actas, Mi Perfil
      final associateMenu = getMenuListForRole(UserRole.associateLawyer);
      final associateTitles = associateMenu.map((m) => m.menuTitle).toList();
      expect(associateTitles, contains('Mi Despacho'));
      expect(associateTitles, isNot(contains('Mis Casos Asignados')));
      expect(associateTitles, contains('Dictámenes & Actas'));
      expect(associateTitles, contains('Mi Perfil'));
      expect(associateTitles.length, 3);
      expect(associateTitles, isNot(contains('Abogados')));
      expect(associateTitles, isNot(contains('Cooperativas')));

      // 2. clientDriver: sees Portal Conductor SOS and Mi Perfil
      final driverMenu = getMenuListForRole(UserRole.clientDriver);
      final driverTitles = driverMenu.map((m) => m.menuTitle).toList();
      expect(driverTitles, contains('Portal Conductor SOS'));
      expect(driverTitles, contains('Mi Perfil'));
      expect(driverTitles.length, 2);
      expect(driverTitles, isNot(contains('Siniestros')));
      expect(driverTitles, isNot(contains('Abogados')));

      // 3. itAdmin: sees all modules (full access)
      final itAdminMenu = getMenuListForRole(UserRole.itAdmin);
      expect(itAdminMenu.length, menuList.length);

      // 4. adminLawyer: sees dispatch modules, client, and Mi Perfil
      final adminLawyerMenu = getMenuListForRole(UserRole.adminLawyer);
      expect(adminLawyerMenu.length, 3);
      expect(adminLawyerMenu.last.subMenus?.length, 5);
    });

    testWidgets('Role switcher bottom sheet renders without overflow on 360px mobile', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      Get.put<ThemeController>(ThemeController(sharedPreferences: prefs));

      authController.switchRole(UserRole.itAdmin, navigate: false);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            appBar: LegalMobileNavHeader(
              title: 'Mi Despacho',
              subtitle: 'Espacio de trabajo',
              activeIndex: 0,
            ),
            body: Center(child: Text('Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the role badge in the header
      final roleBadgeFinder = find.text(UserRole.itAdmin.shortBadge);
      expect(roleBadgeFinder, findsOneWidget);
      await tester.tap(roleBadgeFinder);
      await tester.pumpAndSettle();

      // Verify the sheet opened and shows the ACTIVO badge
      expect(find.text("Simulador de Roles (RBAC)"), findsOneWidget);
      expect(find.text("ACTIVO"), findsOneWidget);
      expect(find.text(UserRole.itAdmin.displayName), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Role switcher bottom sheet renders without overflow on 320px ultra-compact mobile', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      Get.put<ThemeController>(ThemeController(sharedPreferences: prefs));

      authController.switchRole(UserRole.itAdmin, navigate: false);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            appBar: LegalMobileNavHeader(
              title: 'Mi Despacho',
              subtitle: 'Espacio de trabajo',
              activeIndex: 0,
            ),
            body: Center(child: Text('Content')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final roleBadgeFinder = find.text(UserRole.itAdmin.shortBadge);
      expect(roleBadgeFinder, findsOneWidget);
      await tester.tap(roleBadgeFinder);
      await tester.pumpAndSettle();

      expect(find.text("Simulador de Roles (RBAC)"), findsOneWidget);
      expect(find.text("ACTIVO"), findsOneWidget);
      expect(find.text(UserRole.itAdmin.displayName), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('LegalCenterScreen renders and switches modes without Unexpected null value', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      Get.put<ThemeController>(ThemeController(sharedPreferences: prefs));

      authController.switchRole(UserRole.adminLawyer, navigate: false);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: LegalCenterScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.takeException(), isNull);

      final mapBtn = find.text('Mapa');
      if (mapBtn.evaluate().isNotEmpty) {
        await tester.tap(mapBtn.first);
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);

      final splitBtn = find.text('Dividida');
      if (splitBtn.evaluate().isNotEmpty) {
        await tester.tap(splitBtn.first);
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);

      final tableBtn = find.text('Tabla');
      if (tableBtn.evaluate().isNotEmpty) {
        await tester.tap(tableBtn.first);
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(tester.takeException(), isNull);

      // Now switch to associateLawyer
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Switch to clientDriver
      authController.switchRole(UserRole.clientDriver, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Switch to itAdmin
      authController.switchRole(UserRole.itAdmin, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Switch back to adminLawyer
      authController.switchRole(UserRole.adminLawyer, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Drain all pending snackbar timers and animations
      await tester.pumpAndSettle(const Duration(seconds: 5));
    });
  });
}

