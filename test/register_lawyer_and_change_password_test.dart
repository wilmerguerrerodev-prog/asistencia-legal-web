import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/feature/auth/view/change_temporary_password_screen.dart';
import 'package:getdash/feature/auth/view/login_screen.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/view/legal_lawyers_screen.dart';
import 'package:getdash/feature/legal_center/widgets/register_lawyer_dialog.dart';
import 'package:getdash/feature/legal_center/widgets/territory_lawyers_grid.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/menu/model/menu_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    Get.reset();
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    final sp = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sp);
    Get.put(ThemeController(sharedPreferences: sp));
    Get.put(LocalizationController(sharedPreferences: sp));
    Get.put(LanguageController());
    Get.put(MenuDrawerController());
    Get.put(AuthMockController(), permanent: true);
    Get.put(ConductorController(), permanent: true);
    Get.put(LegalCenterController(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  group('Formulario de Registro de Nuevos Abogados Tests', () {
    testWidgets('RegisterLawyerDialog renders all fields and buttons without overflow', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 500,
                height: 700,
                child: RegisterLawyerDialog(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Registrar Nuevo Abogado'), findsOneWidget);
      expect(find.text('Nombre Completo (ej: Dr. Carlos Revelo)'), findsOneWidget);
      expect(find.text('Cédula de Identidad (10 dígitos)'), findsOneWidget);
      expect(find.text('Correo Electrónico Profesional'), findsOneWidget);
      expect(find.text('Celular / Teléfono'), findsOneWidget);
      expect(find.text('Cantón de Cobertura'), findsOneWidget);
      expect(find.text('Matrícula del Foro de Abogados'), findsOneWidget);
      expect(find.text('Contraseña Temporal (Editable)'), findsOneWidget);
      expect(find.text('Guardar Abogado'), findsOneWidget);
    });

    testWidgets('RegisterLawyerDialog validates required fields and Cedula 10 digits', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RegisterLawyerDialog(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap guardar sin llenar datos
      await tester.tap(find.text('Guardar Abogado'));
      await tester.pumpAndSettle();

      expect(find.text('Por favor ingresa el nombre del abogado.'), findsOneWidget);
      expect(find.text('Ingresa la cédula de identidad.'), findsOneWidget);
      expect(find.text('Por favor ingresa el correo profesional.'), findsOneWidget);
    });

    testWidgets('RegisterLawyerDialog saves lawyer, calls onSaveLawyer, and shows credentials modal', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      bool onRegisteredCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RegisterLawyerDialog(
              onRegistered: (data) {
                onRegisteredCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Llenar campos
      final textFields = find.byType(TextFormField);
      // 0: Nombre, 1: Cédula, 2: Teléfono, 3: Email, 4: Matrícula, 5: Password
      await tester.enterText(textFields.at(0), 'Dr. Carlos Revelo');
      await tester.enterText(textFields.at(1), '1003456789');
      await tester.enterText(textFields.at(2), '0991234567');
      await tester.enterText(textFields.at(3), 'carlos.revelo@legaltech.ec');
      await tester.enterText(textFields.at(4), '10-2022-315-CJ');

      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar Abogado'));
      await tester.pumpAndSettle();

      expect(onRegisteredCalled, isTrue);

      // Modal de confirmación de credenciales
      expect(find.text('¡Abogado Registrado Exitosamente!'), findsOneWidget);
      expect(find.text('Copiar datos'), findsOneWidget);
      expect(find.text('Aceptar'), findsOneWidget);

      await tester.tap(find.text('Aceptar'));
      await tester.pumpAndSettle();
    });
  });

  group('Pantalla de Cambio Obligatorio de Contraseña Tests', () {
    testWidgets('ChangeTemporaryPasswordScreen renders security indicators and inputs', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;
      authCtrl.switchUser(AuthMockController.mockTempLawyer, navigate: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: ChangeTemporaryPasswordScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bienvenido al Despacho LegalTech'), findsOneWidget);
      expect(find.text('Por seguridad, debes cambiar tu contraseña temporal antes de acceder a tu espacio de trabajo.'), findsOneWidget);
      expect(find.text('Nueva Contraseña'), findsOneWidget);
      expect(find.text('Confirmar Nueva Contraseña'), findsOneWidget);
      expect(find.text('Mínimo 6 caracteres'), findsOneWidget);
      expect(find.text('Las contraseñas coinciden'), findsOneWidget);
      expect(find.text('Guardar y Acceder a mi Despacho'), findsOneWidget);
    });

    testWidgets('ChangeTemporaryPasswordScreen validates passwords match and updates debeCambiarClave', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;
      authCtrl.switchUser(AuthMockController.mockTempLawyer, navigate: false);
      expect(authCtrl.user.debeCambiarClave, isTrue);

      await tester.pumpWidget(
        const MaterialApp(
          home: ChangeTemporaryPasswordScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      // Ingresar clave corta
      await tester.enterText(textFields.at(0), '123');
      await tester.enterText(textFields.at(1), '123');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar y Acceder a mi Despacho'));
      await tester.pumpAndSettle();

      expect(find.text('Mínimo 6 caracteres requeridos.'), findsOneWidget);

      // Ingresar contraseñas que no coinciden
      await tester.enterText(textFields.at(0), 'NuevaClaveSegura123!');
      await tester.enterText(textFields.at(1), 'OtraClaveDistinta!');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar y Acceder a mi Despacho'));
      await tester.pumpAndSettle();

      expect(find.text('Las contraseñas no coinciden.'), findsOneWidget);

      // Ingresar contraseñas válidas e idénticas
      await tester.enterText(textFields.at(0), 'NuevaClaveSegura123!');
      await tester.enterText(textFields.at(1), 'NuevaClaveSegura123!');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Guardar y Acceder a mi Despacho'));
      await tester.pump(const Duration(milliseconds: 600));

      // Se actualiza el estado debeCambiarClave a false
      expect(authCtrl.user.debeCambiarClave, isFalse);
    });
  });

  group('Login Flow Interception & Role Permissions Tests', () {
    testWidgets('LoginScreen shows demo card for Dr. Carlos Revelo with temporary password', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final quickCard = find.text('Nuevo Abogado (Dr. Carlos Revelo)');
      expect(quickCard, findsOneWidget);
      expect(find.text('1er Login'), findsOneWidget);
    });

    testWidgets('Director Legal can see + Registrar Nuevo Abogado button', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;
      authCtrl.switchUser(AuthMockController.mockAdminLawyer, navigate: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegalLawyersScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('+ Registrar Nuevo Abogado'), findsOneWidget);
    });

    testWidgets('IT Admin can see + Registrar Nuevo Abogado button', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;
      authCtrl.switchUser(AuthMockController.mockItAdmin, navigate: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegalLawyersScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('+ Registrar Nuevo Abogado'), findsOneWidget);
    });

    testWidgets('Associate lawyer or client driver does not see + Registrar Abogado button in TerritoryGrid', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;
      authCtrl.switchUser(AuthMockController.mockClientDriver, navigate: false);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TerritoryLawyersGrid(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('+ Registrar Abogado'), findsNothing);
      expect(find.text('+ Registrar'), findsNothing);
    });

    test('Menu for Legal Director contains Centro de Mando and omits redundant Dashboard Abogado', () {
      final legalDirectorMenu = getMenuListForRole(UserRole.adminLawyer);

      // Debe contener "Centro de Mando"
      final hasCentroMando = legalDirectorMenu.any((m) => m.menuTitle == 'Centro de Mando');
      expect(hasCentroMando, isTrue);

      // Los submenús de Asistencia Jurídica no deben incluir 'dashboard_abogado'
      final asistenciaJuridica = legalDirectorMenu.firstWhere((m) => m.menuTitle == 'asistencia_juridica');
      final subMenuTitles = asistenciaJuridica.subMenus?.map((s) => s.subMenuTitle).toList() ?? [];

      expect(subMenuTitles.contains('dashboard_abogado'), isFalse);
      expect(subMenuTitles.contains('casos_siniestros'), isTrue);
      expect(subMenuTitles.contains('abogados_territorio'), isTrue);
      expect(subMenuTitles.contains('cooperativas_flotas'), isTrue);
      expect(subMenuTitles.contains('dictamenes_actas'), isTrue);
    });
  });
}
