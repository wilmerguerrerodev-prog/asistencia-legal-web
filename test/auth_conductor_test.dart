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
import 'package:getdash/feature/menu/model/menu_model.dart';
import 'package:getdash/feature/users/user_profile_screen.dart';
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

  testWidgets('LoginScreen: Renders simplified minimalist conductor login',
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
    expect(find.text('Bienvenido a LegalTech'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsNWidgets(2)); // Title and Button
    expect(find.text('Cédula de Identidad o Correo'), findsOneWidget);
    expect(find.text('Contraseña o PIN'), findsOneWidget);
    expect(find.text('Recordar en este teléfono'), findsOneWidget);
    expect(find.text('Regístrate aquí'), findsOneWidget);
    expect(find.text('PORTAL DEL CONDUCTOR'), findsNothing);
    expect(find.text('Continuar con Google'), findsNothing);
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

    // Step 1: Quick Auth Screen
    expect(find.text('LegalTech'), findsOneWidget);
    expect(find.text('Bienvenido a LegalTech'), findsOneWidget);
    expect(find.text('Registro de Cuenta'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);
    expect(find.text('Continuar con Apple'), findsOneWidget);
    expect(find.text('Correo Electrónico'), findsOneWidget);

    // Fast-track via Google authentication
    final btnGoogle = find.text('Continuar con Google');
    await tester.ensureVisible(btnGoogle);
    await tester.tap(btnGoogle);
    await tester.pumpAndSettle();

    // Step 2: Driver Profile & License Screen
    expect(find.text('Datos del Conductor'), findsOneWidget);
    expect(find.text('Foto de Perfil Verificada'), findsOneWidget);
    expect(find.text('IDENTIDAD Y LICENCIA PROFESIONAL'), findsOneWidget);
    expect(find.text('Tipo de Licencia de Conducir'), findsOneWidget);
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
    final btnCompletar = find.text('Completar Registro');
    await tester.ensureVisible(btnCompletar);
    await tester.tap(btnCompletar);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    final controller = Get.find<ConductorController>();
    expect(controller.nombreConductor, 'Carlos Alberto Mendoza');
    expect(controller.unidadTaxi, 'Unidad #42');
    expect(controller.cooperativa, 'Cooperativa Los Lagos');
    expect(controller.fotoConductor, 'assets/images/profile_image.jpg');
  });

  testWidgets('UserProfile: Renders Conductor profile and switches to Lawyer profile',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: light,
        home: const UserProfile(),
      ),
    );
    await tester.pumpAndSettle();

    // Conductor profile is shown by default
    expect(find.text('Perfil Conductor'), findsOneWidget);
    expect(find.text('Perfil Abogado'), findsOneWidget);
    expect(find.text('Conductor Verificado'), findsOneWidget);
    expect(find.text('Credenciales de Tránsito (ANT Ecuador)'), findsOneWidget);
    expect(find.text('Vehículo y Cooperativa'), findsOneWidget);
    expect(find.text('Protección Vial LegalTech 24/7'), findsOneWidget);
    expect(find.text('Ir al Botón SOS Vial'), findsNothing);
    expect(find.text('Cerrar Sesión'), findsOneWidget);

    // Tap Cerrar Sesión and verify confirmation dialog appears
    final btnCerrarSesion = find.text('Cerrar Sesión');
    await tester.ensureVisible(btnCerrarSesion);
    await tester.tap(btnCerrarSesion);
    await tester.pumpAndSettle();

    expect(find.text('¿Cerrar Sesión?'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Sí, Salir'), findsOneWidget);

    // Tap Cancelar and verify dialog closes
    final btnCancelar = find.text('Cancelar');
    await tester.tap(btnCancelar);
    await tester.pumpAndSettle();
    expect(find.text('¿Cerrar Sesión?'), findsNothing);

    // Switch to Abogado profile
    final btnAbogado = find.text('Perfil Abogado');
    await tester.ensureVisible(btnAbogado);
    await tester.tap(btnAbogado);
    await tester.pumpAndSettle();

    expect(find.text('Abogado Acreditado'), findsOneWidget);
    expect(find.text('Acreditación y Títulos Profesionales'), findsOneWidget);
    expect(find.text('Despacho y Cobertura Territorial'), findsOneWidget);
    expect(find.text('Servicio y Asistencia 24/7 Activa'), findsOneWidget);
    expect(find.text('Ir al Panel de Casos'), findsOneWidget);
  });

  test('MenuDrawer menuList includes Mi Perfil after LegalTech Cliente', () {
    expect(menuList.length, greaterThanOrEqualTo(2));
    expect(menuList[0].menuTitle, 'LegalTech Cliente');
    expect(menuList[1].menuTitle, 'Mi Perfil');
  });
}
