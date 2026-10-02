import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/conductor/suscripcion_conductor_screen.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/menu/model/menu_model.dart';

import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
    Get.put(AuthMockController());
    Get.put(ConductorController());
  });

  testWidgets('SuscripcionConductorScreen renders informative subscription details cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final conductorController = Get.find<ConductorController>();
    conductorController.actualizarSuscripcion(
      estado: "Activo y Protegido",
      activa: true,
      plan: "Cobertura Total 24/7 (\$1.00 / mes)",
      ultimoPago: "15 de Septiembre, 2026",
      vencimiento: "15 de Octubre, 2026",
      diasRestantes: 14,
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SuscripcionConductorScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Cabecera y Título
    expect(find.text('Mi Suscripción'), findsWidgets);
    expect(find.text('Estado de tu membresía legal y cobertura activa'), findsOneWidget);

    // 2. Estado
    expect(find.text('Activo y Protegido'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);

    // 3. Plan actual
    expect(find.text('PLAN ACTUAL DE COBERTURA'), findsOneWidget);
    expect(find.text('Cobertura Total 24/7 (\$1.00 / mes)'), findsOneWidget);

    // 4. Último pago realizado
    expect(find.text('ÚLTIMO PAGO REALIZADO'), findsOneWidget);
    expect(find.text('15 de Septiembre, 2026'), findsOneWidget);

    // 5. Próximo corte / vencimiento
    expect(find.text('PRÓXIMO CORTE / FECHA DE VENCIMIENTO'), findsOneWidget);
    expect(find.text('15 de Octubre, 2026'), findsOneWidget);
    expect(find.text('Te quedan 14 días de cobertura activa'), findsOneWidget);

    // 6. Datos del Afiliado
    expect(find.text('DATOS DEL AFILIADO'), findsOneWidget);
    expect(find.textContaining('Carlos Mendoza'), findsWidgets);
    expect(find.textContaining('Unidad #42'), findsWidgets);
    expect(find.textContaining('Coo. Los Lagos'), findsWidgets);

    // 7. Ausencia de botones de renovación o lista de beneficios
    expect(find.text('Renovar'), findsNothing);
    expect(find.text('Pagar'), findsNothing);
    expect(find.text('Beneficios activos'), findsNothing);

    // 8. Botón volver
    expect(find.byKey(const Key('btn_volver_desde_suscripcion')), findsOneWidget);
  });

  test('MenuModel includes Mi Suscripcion in clientDriver list', () {
    final driverMenu = getMenuListForRole(UserRole.clientDriver);
    final subscriptionItem = driverMenu.firstWhere((m) => m.menuTitle == 'Mi Suscripción');
    expect(subscriptionItem.route, '/conductorSuscripcion');
    expect(subscriptionItem.iconData, Icons.card_membership_rounded);
  });
}
