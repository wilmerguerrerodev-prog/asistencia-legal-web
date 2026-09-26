import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
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
    await tapVisible('Regresar');

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

    // Regresar y probar HERIDOS -> Alerta Penal Lesiones (Art. 379 COIP)
    await tapVisible('Regresar');
    await tapVisible('HAY PERSONAS HERIDAS');

    expect(find.text('ALERTA PENAL PRIORITARIA — LESIONES'), findsOneWidget);
    expect(
        find.text(
            'Accidente con Víctimas Heridas (Presunto Delito de Lesiones)'),
        findsOneWidget);

    // Regresar y probar SOLO DAÑOS -> Pasa a evaluación vehicular
    await tapVisible('Regresar');
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

    expect(link, startsWith('https://wa.me/593979376024?text='));
    final decodedText = Uri.decodeComponent(link.split('?text=')[1]);
    expect(decodedText, contains('ALERTA SOS - ASISTENCIA LEGAL'));
    expect(decodedText, contains('Carlos Mendoza'));
    expect(decodedText, contains('Unidad #42 - Coo. Los Lagos'));
    expect(decodedText, contains('IBA-1234'));
    expect(decodedText, contains('Procedimiento de Control Vial y Garantías'));
    expect(decodedText,
        contains('Ubicación no disponible al momento del incidente'));
  });

  test(
      'ConductorController.obtenerEnlaceWhatsApp includes Google Maps link when position is available',
      () {
    final controller = ConductorController();
    controller.seleccionarIncidente(TipoIncidente.meChoque);
    controller.posicionActual.value = Position(
      latitude: -0.22985,
      longitude: -78.52495,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 2800.0,
      altitudeAccuracy: 5.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    final link = controller.obtenerEnlaceWhatsApp();
    final decodedText = Uri.decodeComponent(link.split('?text=')[1]);
    expect(
        decodedText, contains('https://maps.google.com/?q=-0.22985,-78.52495'));
  });

  testWidgets(
      'SosConductorView: Asignación por cercanía en Paso 3 y escalamiento al Super Abogado Dr. Emir Vásquez',
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

    // 1. Verificar que en reposo NO hay abogado asignado fijo debajo de documentos
    expect(find.text('Documentos'), findsOneWidget);
    expect(find.text('Credencial'), findsNothing);
    expect(find.text('Dr. Esteban Narváez'), findsNothing);
    expect(find.text('Dr. Emir Vásquez'), findsNothing);

    // 2. Avanzar a Paso 3 (Dictamen): Asignación automática del abogado más cercano
    final opcionOperativo =
        find.text('Operativo de Tránsito / Retención Ilegal');
    await tester.ensureVisible(opcionOperativo);
    await tester.tap(opcionOperativo);
    await tester.pumpAndSettle();

    // En Paso 3 aparece automáticamente el abogado de zona más cercano (Dr. Esteban Narváez)
    expect(find.text('Dr. Esteban Narváez'), findsOneWidget);
    expect(find.textContaining('A 1.2 km de tu incidente'), findsNothing);
    expect(find.text('Contactar con abogado'), findsOneWidget);

    // Abrir credencial del abogado de zona
    final pillVerCredencial = find.text('Ver credencial ›');
    await tester.ensureVisible(pillVerCredencial);
    await tester.tap(pillVerCredencial);
    await tester.pumpAndSettle();

    expect(find.text('DEFENSA LEGAL CERTIFICADA'), findsOneWidget);
    expect(find.text('Dr. Esteban Narváez'), findsWidgets);
    expect(find.text('FORMACIÓN ACADÉMICA (SENESCYT)'), findsOneWidget);
    expect(find.text('TRAYECTORIA Y RESPALDO'), findsOneWidget);
    expect(find.text('Cerrar credencial'), findsOneWidget);

    // Cerrar credencial
    await tester.tap(find.byKey(const Key('btn_cerrar_credencial_modal')));
    await tester.pumpAndSettle();
    expect(find.text('DEFENSA LEGAL CERTIFICADA'), findsNothing);

    // 3. Iniciar contacto con abogado de zona: se activa temporizador de 1 minuto
    final btnContactarZona = find.text('Contactar con abogado');
    await tester.ensureVisible(btnContactarZona);
    await tester.tap(btnContactarZona);
    await tester.pump();

    expect(find.textContaining('Esperando respuesta'), findsOneWidget);
    expect(find.text('¿No contesta? Conectar con otro abogado ahora'),
        findsOneWidget);

    // 4. Escalar caso al Dr. Emir Vásquez
    final btnEscalar = find.text('¿No contesta? Conectar con otro abogado ahora');
    await tester.ensureVisible(btnEscalar);
    await tester.tap(btnEscalar);
    await tester.pumpAndSettle();

    // Verificar que el caso ahora está a cargo de Dr. Emir Vásquez (sin etiquetas redundantes)
    expect(find.text('Dr. Emir Vásquez'), findsOneWidget);
    expect(find.text('Caso asignado a otro abogado'), findsNothing);
    expect(find.text('Contactar con Dr. Emir Vásquez'), findsOneWidget);

    // 5. Abrir credencial del Dr. Emir Vásquez
    final pillVerCredencialSuper = find.text('Ver credencial ›');
    await tester.ensureVisible(pillVerCredencialSuper);
    await tester.tap(pillVerCredencialSuper);
    await tester.pumpAndSettle();

    expect(find.text('DEFENSA LEGAL CERTIFICADA'), findsOneWidget);
    expect(find.text('Dr. Emir Vásquez'), findsWidgets);
    expect(
        find.text('Doctor en Jurisprudencia y Abogado de la República'),
        findsOneWidget);
    expect(find.text('Matrícula F.A. 17-2010-415 · Pichincha / Corte Nacional'),
        findsOneWidget);
    expect(find.text('Director Jurídico Nacional'), findsWidgets);
    expect(find.text('Vásquez & Asociados · Despacho Matriz Nacional'),
        findsWidgets);
  });

  test(
      'ConductorController: Temporizador de 1 minuto (60s) y escalamiento al Dr. Emir Vásquez',
      () {
    final controller = ConductorController();
    expect(controller.abogadoActivo.nombre, 'Dr. Esteban Narváez');
    expect(controller.segundosRestantes.value, 60);
    expect(controller.casoEscaladoASuperAbogado.value, false);

    controller.iniciarLlamada();
    expect(controller.llamadaIniciada.value, true);
    expect(controller.segundosRestantes.value, 60);

    // Escalar al Dr. Emir Vásquez
    controller.escalarASuperAbogado();
    expect(controller.casoEscaladoASuperAbogado.value, true);
    expect(controller.abogadoActivo.nombre, 'Dr. Emir Vásquez');
    expect(controller.abogadoActivo.esSuperAbogado, true);
    expect(controller.telefonoAbogado, '+593 99 876 5432');
    expect(controller.matriculaAbogado,
        '17-2010-415 · Pichincha / Corte Nacional');

    // Comprobar que el mensaje de WhatsApp se actualiza con los datos del Dr. Emir Vásquez
    final mensaje = controller.obtenerMensajeWhatsApp();
    expect(mensaje, contains('TRANSFERIDO A DR. EMIR VÁSQUEZ'));
    expect(controller.obtenerEnlaceWhatsApp(), startsWith('https://wa.me/593998765432'));

    // Reiniciar flujo y verificar regreso a estado inicial con abogado de zona
    controller.reiniciarFlujo();
    expect(controller.casoEscaladoASuperAbogado.value, false);
    expect(controller.abogadoActivo.nombre, 'Dr. Esteban Narváez');
    expect(controller.segundosRestantes.value, 60);
    expect(controller.llamadaIniciada.value, false);
  });
}

