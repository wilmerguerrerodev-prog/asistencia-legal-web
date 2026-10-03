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
      'SosConductorView mobile flow: Menú reordenado, triage diferenciado para los 5 casos y nuevo flujo Tengo otro problema',
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
    expect(find.text('Grupo Ecuador Total Abogados'), findsOneWidget);
    expect(find.text('Operativo de Tránsito'), findsOneWidget);

    await tapVisible('Operativo de Tránsito');

    expect(find.text('GARANTÍAS Y CONTROL VIAL'), findsOneWidget);
    expect(
        find.text('Procedimiento de Control Vial y Garantías'), findsOneWidget);
    expect(find.text('EN GUARDIA 24/7'), findsNothing);
    expect(find.textContaining('LLAMAR A MI ABOGADO ASIGNADO'), findsNothing);
    expect(find.textContaining('Llama, él es tu abogado'), findsWidgets);

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
        find.text('Vehículo Inmovilizado por Impacto de Tercero'), findsOneWidget);

    // -------------------------------------------------------------
    // CASO 4: Agresión física / Riña personal (Opción 1 prioritaria arriba)
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

    // -------------------------------------------------------------
    // CASO 5: Encarcelaron un familiar (Detención urgente penal)
    // -------------------------------------------------------------
    await tapVisible('Nuevo caso');

    expect(find.text('Encarcelaron un familiar'), findsOneWidget);
    await tapVisible('Encarcelaron un familiar');

    // Pasa directo al dictamen penal por detención/flagrancia
    expect(
        find.text('EMERGENCIA PENAL — DETENCIÓN / FLAGRANCIA'), findsOneWidget);
    expect(find.text('Protección Legal Inmediata por Detención de Familiar'),
        findsOneWidget);
    expect(find.textContaining('Art. 77 Constitución'), findsOneWidget);

    // -------------------------------------------------------------
    // CASO 6: Tengo otro problema (6ta opción)
    // -------------------------------------------------------------
    await tapVisible('Nuevo caso');

    expect(find.text('Tengo otro problema'), findsOneWidget);
    await tapVisible('Tengo otro problema');

    // Validar formulario de caso personalizado
    expect(find.text('PASO 2 DE 3: CUÉNTANOS TU CASO'), findsOneWidget);
    expect(find.text('¿Qué situación o problema legal tienes?'), findsOneWidget);
    expect(find.text('⚖️ Despido intempestivo'), findsOneWidget);
    expect(find.text('CONTINUAR CON ASESORÍA LEGAL'), findsOneWidget);

    // Tocar chip de categoría rápida y continuar
    await tapVisible('⚖️ Despido intempestivo');
    await tapVisible('CONTINUAR CON ASESORÍA LEGAL');

    // Validar dictamen especializado
    expect(find.text('ASESORÍA JURÍDICA ESPECIALIZADA'), findsOneWidget);
    expect(find.textContaining('Código del Trabajo'), findsOneWidget);
    expect(
        find.textContaining('NO FIRMES DOCUMENTOS EN BLANCO'), findsOneWidget);
  });

  testWidgets('IncidenteVectorIcon renders all 6 incident types properly',
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

    expect(link, startsWith('https://wa.me/593988456189?text='));
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

  test(
      'ConductorController.obtenerEnlaceWhatsApp includes custom description for otroProblema',
      () {
    final controller = ConductorController();
    controller.seleccionarIncidente(TipoIncidente.otroProblema);
    controller.enviarOtroProblema('Despido intempestivo tras 5 años');
    final link = controller.obtenerEnlaceWhatsApp();

    expect(link, startsWith('https://wa.me/593988456189?text='));
    final decodedText = Uri.decodeComponent(link.split('?text=')[1]);
    expect(decodedText, contains('ALERTA SOS - ASISTENCIA LEGAL'));
    expect(decodedText,
        contains('*Detalle del caso:* Despido intempestivo tras 5 años'));
    expect(decodedText, contains('Protección y Asesoría Legal Inmediata: Despido intempestivo tras 5 años'));
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

    // 1. Verificar que en la pantalla inicial NO se muestra contacto con abogado ni documentos antiguos
    expect(find.text('Documentos'), findsNothing);
    expect(find.text('Quiénes somos'), findsOneWidget);
    expect(find.text('Ver más'), findsOneWidget);
    expect(find.text('Credencial'), findsNothing);
    expect(find.text('ABOGADO DE GUARDIA 24/7 EN LÍNEA'), findsNothing);
    expect(find.textContaining('Llama, él es tu abogado'), findsNothing);
    expect(find.textContaining('WhatsApp de auxilio'), findsNothing);
    expect(find.text('¿Hola, cuál es tu problema?'), findsOneWidget);

    // 2. Avanzar a Paso 3 (Dictamen): Asignación automática del abogado más cercano
    final opcionOperativo =
        find.text('Operativo de Tránsito');
    await tester.ensureVisible(opcionOperativo);
    await tester.tap(opcionOperativo);
    await tester.pumpAndSettle();

    // En Paso 3 aparece el despacho asignado (Grupo Ecuador Total Abogados) y los botones de acción rápida
    expect(find.text('Grupo Ecuador Total Abogados'), findsWidgets);
    expect(find.textContaining('A 1.2 km de tu incidente'), findsNothing);
    expect(find.textContaining('Llama, él es tu abogado'), findsWidgets);
    expect(find.text('Llamar'), findsWidgets);
    expect(find.text('WhatsApp'), findsWidgets);

    // Abrir credencial del abogado
    final pillVerCredencial = find.text('Ver credencial ›');
    await tester.ensureVisible(pillVerCredencial);
    await tester.tap(pillVerCredencial);
    await tester.pumpAndSettle();

    expect(find.text('DEFENSA LEGAL CERTIFICADA'), findsOneWidget);
    expect(find.text('Grupo Ecuador Total Abogados'), findsWidgets);
    expect(find.text('FORMACIÓN ACADÉMICA (SENESCYT)'), findsOneWidget);
    expect(find.text('TRAYECTORIA Y RESPALDO'), findsOneWidget);
    expect(find.text('Cerrar credencial'), findsOneWidget);

    // Cerrar credencial
    await tester.tap(find.byKey(const Key('btn_cerrar_credencial_modal')));
    await tester.pumpAndSettle();
    expect(find.text('DEFENSA LEGAL CERTIFICADA'), findsNothing);

    // 3. Iniciar contacto directo con Dr. Emir Vásquez
    final btnContactarZona = find.byKey(const Key('btn_llamar_abogado_paso3')).first;
    await tester.ensureVisible(btnContactarZona);
    await tester.tap(btnContactarZona);
    await tester.pump();

    expect(Get.find<ConductorController>().llamadaIniciada.value, true);
    expect(find.textContaining('+593 98 845 6189'), findsWidgets);

    Get.find<ConductorController>().reiniciarFlujo();
    await tester.pump();
  });

  test(
      'ConductorController: Contacto directo prioritario con Grupo Ecuador Total Abogados',
      () {
    final controller = ConductorController();
    expect(controller.abogadoActivo.nombre, 'Grupo Ecuador Total Abogados');
    expect(controller.telefonoAbogado, '+593 98 845 6189');
    expect(controller.matriculaAbogado,
        '17-2010-415 · Pichincha / Corte Nacional');

    controller.iniciarLlamada();
    expect(controller.llamadaIniciada.value, true);

    // Comprobar que el mensaje de WhatsApp contiene los datos del Dr. Emir Vásquez
    final mensaje = controller.obtenerMensajeWhatsApp();
    expect(mensaje, contains('ALERTA SOS - ASISTENCIA LEGAL'));
    expect(controller.obtenerEnlaceWhatsApp(), startsWith('https://wa.me/593988456189'));

    // Reiniciar flujo
    controller.reiniciarFlujo();
    expect(controller.abogadoActivo.nombre, 'Grupo Ecuador Total Abogados');
    expect(controller.llamadaIniciada.value, false);
  });

  testWidgets('Abrir modal institucional de Grupo Ecuador Total Abogados',
      (WidgetTester tester) async {
    final controller = ConductorController();
    Get.put<ConductorController>(controller);

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

    final btnVerMas = find.text('Ver más');
    await tester.ensureVisible(btnVerMas);
    await tester.tap(btnVerMas);
    await tester.pumpAndSettle();

    expect(find.text('RESPALDO JURÍDICO OFICIAL'), findsOneWidget);
    expect(find.text('Grupo Ecuador Total Abogados'), findsWidgets);
    expect(find.text('Dr. Emir Vásquez'), findsOneWidget);
    expect(find.text('Doctor en Jurisprudencia · UCE'), findsOneWidget);
    expect(find.textContaining('17-2010-415 Pichincha'), findsOneWidget);
    expect(find.text('Tránsito y Flagrancias (COIP)'), findsOneWidget);
    expect(find.text('Defensa Laboral y Liquidaciones'), findsOneWidget);
    expect(find.text('Plan Piloto Ibarra y Sede Quito'), findsNothing);
    expect(find.textContaining('Consejo Legal'), findsNothing);
    expect(find.byKey(const Key('btn_llamar_firma_modal')), findsNothing);
    expect(find.byKey(const Key('btn_whatsapp_firma_modal')), findsNothing);
    expect(find.byKey(const Key('btn_cerrar_modal_bottom')), findsOneWidget);

    final btnCerrar = find.byKey(const Key('btn_cerrar_modal_bottom'));
    await tester.ensureVisible(btnCerrar);
    await tester.tap(btnCerrar);
    await tester.pumpAndSettle();

    expect(find.text('RESPALDO JURÍDICO OFICIAL'), findsNothing);
  });
}


