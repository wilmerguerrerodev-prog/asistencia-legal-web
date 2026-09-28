import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/theme/light_theme.dart';
import 'package:getdash/feature/auth/view/login_screen.dart';
import 'package:getdash/feature/auth/view/registration_screen.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    final sp = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sp);
    Get.put(ThemeController(sharedPreferences: sp));
    Get.put(LocalizationController(sharedPreferences: sp));
    Get.put(LanguageController());
    Get.put(MenuDrawerController());
    Get.put(ConductorController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoginScreen: Renders branded conductor login and Google button',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: light,
        home: const LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('LegalTech'), findsOneWidget);
    expect(find.text('PORTAL DEL CONDUCTOR'), findsOneWidget);
    expect(find.text('Inicia Sesión'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.text('Cédula de Identidad o Correo'), findsOneWidget);
    expect(find.text('Contraseña o PIN'), findsOneWidget);
    expect(find.text('Recordar en este teléfono'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Acceso Demo: Carlos Mendoza (Unidad #42)'), findsOneWidget);
    expect(find.text('Regístrate aquí'), findsOneWidget);
  });

  testWidgets('RegistrationScreen: Smart Cédula lookup and driver registration flow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: light,
        home: const RegistrationScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Registro de Conductor'), findsOneWidget);
    expect(find.text('Registrarse con Google'), findsOneWidget);
    expect(find.text('DATOS PERSONALES Y LICENCIA'), findsOneWidget);
    expect(find.text('DATOS DEL VEHÍCULO / UNIDAD'), findsOneWidget);

    // Enter 10-digit Cédula
    final cedulaField = find.widgetWithText(TextField, 'Ej. 1002345678');
    await tester.enterText(cedulaField, '1002345678');
    await tester.pump();

    // Trigger consultation
    final btnConsultar = find.text('Consultar');
    await tester.ensureVisible(btnConsultar);
    await tester.tap(btnConsultar);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Verificada'), findsOneWidget);
    expect(find.text('Carlos Alberto Mendoza'), findsOneWidget);

    // Register button
    final btnCompletar = find.text('Completar Registro y Activar Protección');
    await tester.ensureVisible(btnCompletar);
    await tester.tap(btnCompletar);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    final controller = Get.find<ConductorController>();
    expect(controller.nombreConductor, 'Carlos Alberto Mendoza');
    expect(controller.unidadTaxi, 'Unidad #42');
    expect(controller.cooperativa, 'Cooperativa Los Lagos');
  });
}
