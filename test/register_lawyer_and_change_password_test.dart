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
import 'package:getdash/core/helper/route_helper.dart';
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
    testWidgets('LoginScreen allows typing credentials directly in production style', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Ingreso directo de credenciales en campos
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'conductor@legaltech.ec');
      await tester.enterText(textFields.last, 'conductor123');
      await tester.pumpAndSettle();

      expect(find.text('conductor@legaltech.ec'), findsWidgets);
      expect(find.text('conductor123'), findsWidgets);
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

    testWidgets('Temporary password expires after change: old temporary password is rejected with error', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final authCtrl = AuthMockController.to;

      // 1. Registrar nuevo abogado con clave temporal
      await authCtrl.onSaveLawyer(
        nombre: 'Dr. Santiago Test',
        cedula: '1002003001',
        email: 'santiago.test@legaltech.ec',
        telefono: '0991122334',
        canton: 'Otavalo',
        matriculaForo: '10-2026-999-CJ',
        temporaryPassword: 'ClaveTemporal123!',
      );

      final lawyer = authCtrl.findUserByIdentifier('1002003001');
      expect(lawyer, isNotNull);
      expect(lawyer!.debeCambiarClave, isTrue);
      expect(lawyer.temporaryPassword, 'ClaveTemporal123!');

      // 2. Simular cambio de clave por el abogado a "Nuevo123!"
      authCtrl.switchUser(lawyer, navigate: false);
      await authCtrl.onChangePassword(newPassword: 'Nuevo123!');

      final updatedLawyer = authCtrl.findUserByIdentifier('1002003001');
      expect(updatedLawyer!.debeCambiarClave, isFalse);
      expect(updatedLawyer.temporaryPassword, 'Nuevo123!');

      // 3. Montar LoginScreen y probar ingresar con la clave temporal antigua
      authCtrl.switchUser(AuthMockController.mockClientDriver, navigate: false);
      expect(authCtrl.user.cedula, '1002345678');

      await tester.pumpWidget(
        GetMaterialApp(
          home: const LoginScreen(),
          getPages: [
            GetPage(name: RouteHelper.lawyerWorkspaceScreen, page: () => const Scaffold(body: Text('Workspace'))),
            GetPage(name: RouteHelper.changeTemporaryPasswordScreen, page: () => const Scaffold(body: Text('ChangePassword'))),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      final idField = textFields.at(0);
      final passField = textFields.at(1);

      // Ingresar cédula y contraseña TEMPORAL ANTIGUA
      await tester.enterText(idField, '1002003001');
      await tester.enterText(passField, 'ClaveTemporal123!');
      await tester.pumpAndSettle();

      final btnLogin = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.ensureVisible(btnLogin);
      await tester.tap(btnLogin);
      await tester.pumpAndSettle();

      // Debe rechazar el inicio de sesión: el usuario activo NO debe haber cambiado al abogado
      expect(authCtrl.user.cedula, '1002345678');
      expect(authCtrl.user.role, UserRole.clientDriver);

      // 4. Ahora ingresar con la NUEVA contraseña "Nuevo123!"
      await tester.enterText(passField, 'Nuevo123!');
      await tester.pumpAndSettle();

      await tester.tap(btnLogin);
      await tester.pumpAndSettle();

      // Debe autenticar exitosamente con la nueva clave y con debeCambiarClave == false
      expect(authCtrl.user.cedula, '1002003001');
      expect(authCtrl.user.debeCambiarClave, isFalse);
      expect(authCtrl.user.role, UserRole.associateLawyer);
    });
  });
}
