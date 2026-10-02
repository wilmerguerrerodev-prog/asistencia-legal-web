import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/feature/conductor/controller/conductor_controller.dart';
import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/widgets/expediente_360_panel.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/conductor/suscripcion_conductor_screen.dart';
import 'package:getdash/feature/subscriptions/controller/subscriptions_controller.dart';
import 'package:getdash/feature/subscriptions/view/admin_subscriptions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Módulo de Suscripciones y Membresías LegalTech - Suite Completa', () {
    late SubscriptionsController subController;
    late ConductorController conductorController;
    late LegalCenterController legalController;

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
      Get.put<AuthMockController>(AuthMockController());
      conductorController = Get.put<ConductorController>(ConductorController());
      legalController = Get.put<LegalCenterController>(LegalCenterController());
      subController = Get.put<SubscriptionsController>(SubscriptionsController());
    });

    // =========================================================================
    // 1. ROL 1: ADMINISTRADOR TI (itAdmin)
    // =========================================================================
    group('Rol 1: Administrador TI (itAdmin) - Supervisión y Cobros', () {
      test('KPIs comerciales y financieros se calculan correctamente a \$1.00 / mes', () {
        expect(subController.totalConductores, greaterThanOrEqualTo(8));
        expect(subController.totalActivos, greaterThan(0));
        expect(
          subController.ingresosMensualesProyectados,
          equals(subController.totalActivos * 1.00),
        );
        expect(subController.conductoresPorVencer, greaterThan(0));
        expect(subController.conductoresVencidos, greaterThan(0));
      });

      test('Filtros por estado clasifican adecuadamente los afiliados', () {
        // Filtro Al Día
        subController.setStatusFilter('activos');
        for (final sub in subController.filteredSubscriptions) {
          expect(sub.activa, isTrue);
          expect(sub.isVencida, isFalse);
        }

        // Filtro Por Vencer
        subController.setStatusFilter('porVencer');
        for (final sub in subController.filteredSubscriptions) {
          expect(sub.isPorVencer, isTrue);
          expect(sub.diasRestantes, inInclusiveRange(0, 5));
        }

        // Filtro Vencidos
        subController.setStatusFilter('vencidos');
        for (final sub in subController.filteredSubscriptions) {
          expect(sub.isVencida, isTrue);
        }

        // Restablecer filtro
        subController.setStatusFilter('all');
        expect(subController.filteredSubscriptions.length, equals(subController.subscriptions.length));
      });

      test('Renovar / Registrar Pago Manual extiende vigencia +30 días y sincroniza con ConductorController', () {
        // Conductor Carlos Mendoza (DRIVER-042)
        final carlosInicial = subController.subscriptions.firstWhere((s) => s.id == 'DRIVER-042');
        final diasIniciales = carlosInicial.diasRestantes;

        subController.renovarPagoManual(
          driverId: 'DRIVER-042',
          dias: 30,
          metodo: 'Efectivo en Oficina',
        );

        final carlosActualizado = subController.subscriptions.firstWhere((s) => s.id == 'DRIVER-042');
        expect(carlosActualizado.activa, isTrue);
        expect(carlosActualizado.estado, 'Activo y Protegido');
        expect(carlosActualizado.metodoPago, 'Efectivo en Oficina');
        expect(carlosActualizado.diasRestantes, greaterThanOrEqualTo(diasIniciales + 29));

        // Sincronización en vivo con ConductorController
        expect(conductorController.estaSuscripcionActiva.value, isTrue);
        expect(conductorController.estadoSuscripcion.value, 'Activo y Protegido');
        expect(conductorController.diasRestantesSuscripcion.value, equals(carlosActualizado.diasRestantes));
      });

      test('Suspender / Activar Cobertura alterna el estado de la membresía', () {
        final sub = subController.subscriptions.firstWhere((s) => s.id == 'DRIVER-042');
        expect(sub.activa, isTrue);

        // Suspender
        subController.toggleSuspension('DRIVER-042');
        expect(sub.activa, isFalse);
        expect(sub.estado, 'Suspendido por Mora');
        expect(conductorController.estaSuscripcionActiva.value, isFalse);

        // Reactivar
        subController.toggleSuspension('DRIVER-042');
        expect(sub.activa, isTrue);
        expect(conductorController.estaSuscripcionActiva.value, isTrue);
      });

      testWidgets('AdminSubscriptionsScreen renderiza KPIs, tabla y modal de pago manual', (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const GetMaterialApp(
            home: AdminSubscriptionsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Verificar encabezado y títulos
        expect(find.text('Gestión de Suscripciones y Membresías'), findsOneWidget);
        expect(find.text('Total Afiliados'), findsOneWidget);
        expect(find.text('Membresías Activas'), findsOneWidget);

        // Verificar botón Renovar del primer conductor en la tabla
        final btnRenovar = find.byKey(const Key('btn_renovar_DRIVER-042'));
        expect(btnRenovar, findsOneWidget);

        // Abrir modal de pago manual
        await tester.ensureVisible(btnRenovar);
        await tester.tap(btnRenovar);
        await tester.pumpAndSettle();

        expect(find.text('Registrar Pago Manual'), findsOneWidget);
        expect(find.text('Periodo a Renovar:'), findsOneWidget);
        expect(find.byKey(const Key('btn_confirmar_pago_modal')), findsOneWidget);

        // Confirmar pago desde el modal
        await tester.tap(find.byKey(const Key('btn_confirmar_pago_modal')));
        await tester.pumpAndSettle();

        // El modal debe haberse cerrado
        expect(find.text('Registrar Pago Manual'), findsNothing);
      });
    });

    // =========================================================================
    // 2. ROL 2: ABOGADO DIRECTOR / DESPACHO (adminLawyer - Dr. Emir Vásquez)
    // =========================================================================
    group('Rol 2: Abogado Director / Despacho (adminLawyer) - Despacho & Cobertura', () {
      test('LegalCase model incluye atributos de suscripción y helper isMembresiaActiva', () {
        final activoCase = legalController.allCases.firstWhere((c) => c.id == '#CASO-1042');
        expect(activoCase.suscripcionActiva, isTrue);
        expect(activoCase.isMembresiaActiva, isTrue);

        final vencidoCase = legalController.allCases.firstWhere((c) => c.id == '#CASO-1035');
        expect(vencidoCase.suscripcionActiva, isFalse);
        expect(vencidoCase.isMembresiaActiva, isFalse);
      });

      test('Dr. Emir Vásquez puede Autorizar Asistencia Condicionada para caso vencido', () {
        final caseItem = legalController.allCases.firstWhere((c) => c.id == '#CASO-1035');
        expect(caseItem.asistenciaCondicionadaAutorizada, isFalse);

        legalController.autorizarAsistenciaCondicionada('#CASO-1035');

        expect(caseItem.asistenciaCondicionadaAutorizada, isTrue);
        expect(caseItem.isMembresiaActiva, isTrue);
        expect(caseItem.timeline.first.title, contains('Condicionada Autorizada'));
      });

      test('Dr. Emir Vásquez puede Notificar Regularización de Pago', () {
        final caseItem = legalController.allCases.firstWhere((c) => c.id == '#CASO-1035');
        final timelineInicial = caseItem.timeline.length;

        legalController.notificarRegularizacionPago('#CASO-1035');

        expect(caseItem.timeline.length, equals(timelineInicial + 1));
        expect(caseItem.timeline.first.title, contains('Notificación de Regularización'));
      });

      testWidgets('Expediente360Panel muestra botones de decisión para membresía vencida', (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final vencidoCase = legalController.allCases.firstWhere((c) => c.id == '#CASO-1035');
        vencidoCase.asistenciaCondicionadaAutorizada = false;

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Expediente360Panel(caseItem: vencidoCase),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Debe mostrar alerta de membresía vencida y botones de decisión
        expect(find.text('Membresía Vencida • Decisión del Director Legal'), findsOneWidget);
        expect(find.byKey(const Key('btn_autorizar_asistencia_condicionada')), findsOneWidget);
        expect(find.byKey(const Key('btn_notificar_regularizacion')), findsOneWidget);

        // Al pulsar autorizar asistencia condicionada
        await tester.tap(find.byKey(const Key('btn_autorizar_asistencia_condicionada')));
        await tester.pumpAndSettle();

        expect(vencidoCase.asistenciaCondicionadaAutorizada, isTrue);
      });
    });

    // =========================================================================
    // 3. ROL 3: ABOGADO ASOCIADO EN VÍA (associateLawyer)
    // =========================================================================
    group('Rol 3: Abogado Asociado en Vía (associateLawyer) - Alcance y Verificación', () {
      testWidgets('Expediente360Panel muestra el Alcance de la Cobertura detallado', (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final activeCase = legalController.allCases.firstWhere((c) => c.id == '#CASO-1042');

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Expediente360Panel(caseItem: activeCase),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Cliente LegalTech Verificado • Cobertura 24/7 Activa'), findsOneWidget);
        expect(find.textContaining('Alcance de la Cobertura: Patrocinio penal/tránsito'), findsOneWidget);
      });
    });

    // =========================================================================
    // 4. CLIENTE CONDUCTOR SOS (clientDriver)
    // =========================================================================
    group('Cliente Conductor SOS (clientDriver) - Emisión de Alertas', () {
      test('Mensaje de alerta SOS en WhatsApp incluye estado de membresía', () {
        conductorController.actualizarSuscripcion(activa: true, estado: 'Activo y Protegido');
        final msgActivo = conductorController.obtenerMensajeWhatsApp();
        expect(msgActivo, contains('🟢 Activa y Protegida (24/7)'));

        conductorController.actualizarSuscripcion(activa: false, estado: 'Membresía Vencida');
        final msgVencido = conductorController.obtenerMensajeWhatsApp();
        expect(msgVencido, contains('⚠️ Regularización Pendiente'));
      });
    });

    // =========================================================================
    // 5. PRUEBAS DE ADAPTABILIDAD Y PREVENCIÓN DE OVERFLOWS (RESPONSIVE)
    // =========================================================================
    group('Pruebas de Adaptabilidad y Prevención de Overflows', () {
      testWidgets('AdminSubscriptionsScreen no desborda en pantalla móvil estrecha (320px)', (tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const GetMaterialApp(
            home: AdminSubscriptionsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Gestión de Suscripciones y Membresías'), findsOneWidget);
        expect(find.text('Total Afiliados'), findsOneWidget);
      });

      testWidgets('SuscripcionConductorScreen no desborda en pantalla móvil pequeña (320px)', (tester) async {
        tester.view.physicalSize = const Size(320, 600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const GetMaterialApp(
            home: SuscripcionConductorScreen(),
          ),
        );
        await tester.pumpAndSettle();

        final ex = tester.takeException() as FlutterError?;
        if (ex != null) {
          for (final d in ex.diagnostics) {
            debugPrint("NODE: ${d.name} -> ${d.toDescription()}");
            if (d.value != null) {
              debugPrint("VALUE TYPE: ${d.value.runtimeType}");
            }
          }
        }
        expect(ex, isNull);
        expect(find.text('Mi Suscripción'), findsOneWidget);
      });

      testWidgets('Expediente360Panel no desborda en contenedor estrecho (300px) con caso vencido', (tester) async {
        tester.view.physicalSize = const Size(300, 700);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final expiredCase = legalController.allCases.firstWhere((c) => !c.suscripcionActiva);

        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Expediente360Panel(caseItem: expiredCase),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('btn_autorizar_asistencia_condicionada')), findsOneWidget);
        expect(find.byKey(const Key('btn_notificar_regularizacion')), findsOneWidget);
      });
    });
  });
}
