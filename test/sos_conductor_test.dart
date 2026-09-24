import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/theme/light_theme.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/conductor/sos_conductor_view.dart';
import 'package:getdash/feature/conductor/widgets/incidente_vector_icon.dart';
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
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
      'SosConductorView mobile flow: Triage diferenciado para los 4 casos y 3 niveles de víctimas',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: light,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: SosConductorView(isEmbeddedInDashboard: true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> tapVisible(String text) async {
      final finder = find.text(text);
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    // -------------------------------------------------------------
    // CASO 1: Operativo de Tránsito (Paso directo al dictamen)
    // -------------------------------------------------------------
    expect(find.text('LegalTech Conductor'), findsOneWidget);
    expect(
        find.text('Operativo de Tránsito / Retención Ilegal'), findsOneWidget);

    await tapVisible('Operativo de Tránsito / Retención Ilegal');

    expect(find.text('GARANTÍAS Y CONTROL VIAL'), findsOneWidget);
    expect(
        find.text('Procedimiento de Control Vial y Garantías'), findsOneWidget);
    expect(find.text('EN GUARDIA 24/7'), findsNothing);
    expect(find.textContaining('LLAMAR A MI ABOGADO ASIGNADO'), findsNothing);
    expect(find.textContaining('Contactar con abogado'), findsOneWidget);

    // -------------------------------------------------------------
    // CASO 2: Me choqué (Evaluación de fallecido, heridos y daños)
    // -------------------------------------------------------------
    await tapVisible('Reevaluar');

    expect(find.text('Me choqué'), findsOneWidget);
    await tapVisible('Me choqué');

    // Validar las 3 opciones explícitas de víctimas
    expect(find.text('HAY PERSONA FALLECIDA'), findsOneWidget);
    expect(find.text('HAY PERSONAS HERIDAS'), findsOneWidget);
    expect(find.text('NO, SOLO DAÑOS / LATA'), findsOneWidget);

    // Probar opción FALLECIDO -> Alerta Penal Máxima (Art. 377 COIP)
    await tapVisible('HAY PERSONA FALLECIDA');

    expect(
        find.text('ALERTA PENAL MÁXIMA — HOMICIDIO CULPOSO'), findsOneWidget);
    expect(find.text('Accidente de Tránsito con Persona Fallecida'),
        findsOneWidget);

    // Reevaluar y probar HERIDOS -> Alerta Penal Lesiones (Art. 379 COIP)
    await tapVisible('Reevaluar');
    await tapVisible('HAY PERSONAS HERIDAS');

    expect(find.text('ALERTA PENAL PRIORITARIA — LESIONES'), findsOneWidget);
    expect(
        find.text(
            'Accidente con Víctimas Heridas (Presunto Delito de Lesiones)'),
        findsOneWidget);

    // Reevaluar y probar SOLO DAÑOS -> Pasa a evaluación vehicular
    await tapVisible('Reevaluar');
    await tapVisible('NO, SOLO DAÑOS / LATA');

    expect(find.text('SÍ, VEHÍCULO INMOVILIZADO'), findsOneWidget);
    expect(find.text('NO, DAÑOS LEVES O ROZADURA'), findsOneWidget);

    // Probar DAÑOS LEVES -> Conciliación rápida
    await tapVisible('NO, DAÑOS LEVES O ROZADURA');

    expect(find.text('CONCILIACIÓN RÁPIDA EN SITIO'), findsOneWidget);

    // -------------------------------------------------------------
    // CASO 3: Me chocaron (Conductor afectado / Lucro Cesante)
    // -------------------------------------------------------------
    await tapVisible('Nuevo caso');

    expect(find.text('Me chocaron'), findsOneWidget);
    await tapVisible('Me chocaron');

    // Probar que el taxista fue chocado y solo hay daños graves (Lucro cesante)
    await tapVisible('NO, SOLO DAÑOS / LATA');
    await tapVisible('SÍ, VEHÍCULO INMOVILIZADO');

    expect(find.text('EXIGENCIA DE INDEMNIZACIÓN Y LUCRO CESANTE'),
        findsOneWidget);
    expect(
        find.text('Taxi Inmovilizado por Impacto de Tercero'), findsOneWidget);

    // -------------------------------------------------------------
    // CASO 4: Agresión / Problema personal
    // -------------------------------------------------------------
    await tapVisible('Nuevo caso');

    expect(find.text('Agresión / Problema personal'), findsOneWidget);
    await tapVisible('Agresión / Problema personal');

    // Validar opciones adaptadas para altercado personal
    expect(find.text('HAY AGRESIÓN FÍSICA O HERIDOS'), findsOneWidget);
    expect(find.text('SOLO CONFLICTO VERBAL O AMENAZA'), findsOneWidget);

    // Conflicto verbal pasa directo al dictamen de contención
    await tapVisible('SOLO CONFLICTO VERBAL O AMENAZA');

    expect(find.text('PROTECCIÓN Y CONTENCIÓN PERSONAL'), findsOneWidget);
    expect(find.text('Altercado Verbal o Conflicto con Pasajero / Tercero'),
        findsOneWidget);
  });

  testWidgets('IncidenteVectorIcon renders all 4 incident types properly',
      (WidgetTester tester) async {
    for (final tipo in TipoIncidente.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: IncidenteVectorIcon(
                tipo: tipo,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(IncidenteVectorIcon), findsOneWidget);
    }
  });

  test(
      'ConductorController.obtenerEnlaceWhatsApp generates valid wa.me URL with clean phone and case metadata',
      () {
    final controller = ConductorController();
    controller.seleccionarIncidente(TipoIncidente.operativoTransito);
    final link = controller.obtenerEnlaceWhatsApp();

    expect(link, startsWith('https://wa.me/593991234567?text='));
    expect(link, contains('Carlos+Mendoza'));
    expect(link, contains('Unidad+%2342'));
    expect(link, contains('IBA-1234'));
    expect(link, contains('Procedimiento+de+Control+Vial+y+Garant%C3%ADas'));
  });
}
