import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/widgets/legal_realtime_table.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LegalCenterController controller;

  setUp(() {
    Get.reset();
    controller = LegalCenterController();
    controller.onInit();
  });

  group('LegalCenterController - Mapa y Despacho Interactivo', () {
    test('Estado inicial del mapa: modo split, capas activas y centro en Imbabura', () {
      expect(controller.dispatchViewMode, LegalDispatchViewMode.split);
      expect(controller.showIncidentsLayer, isTrue);
      expect(controller.showLawyersLayer, isTrue);
      expect(controller.showRoutesLayer, isTrue);
      expect(controller.targetMapLat, closeTo(0.2800, 0.05));
      expect(controller.targetMapLng, closeTo(-78.2000, 0.05));
      expect(controller.selectedCase, isNotNull);
    });

    test('Cambio reactivo de modos de visualización (Split, TableOnly, MapOnly)', () {
      controller.setDispatchViewMode(LegalDispatchViewMode.tableOnly);
      expect(controller.dispatchViewMode, LegalDispatchViewMode.tableOnly);

      controller.setDispatchViewMode(LegalDispatchViewMode.mapOnly);
      expect(controller.dispatchViewMode, LegalDispatchViewMode.mapOnly);

      controller.setDispatchViewMode(LegalDispatchViewMode.split);
      expect(controller.dispatchViewMode, LegalDispatchViewMode.split);
    });

    test('Toggles de capas del mapa funcionan correctamente', () {
      controller.toggleIncidentsLayer();
      expect(controller.showIncidentsLayer, isFalse);

      controller.toggleLawyersLayer();
      expect(controller.showLawyersLayer, isFalse);

      controller.toggleRoutesLayer();
      expect(controller.showRoutesLayer, isFalse);

      controller.toggleIncidentsLayer();
      expect(controller.showIncidentsLayer, isTrue);
    });

    test('Sincronización de selección de caso: actualiza coordenadas objetivo del mapa y contador', () {
      final initialCounter = controller.mapMoveCounter;
      final testCase = controller.allCases.last;

      controller.selectCase(testCase);

      expect(controller.selectedCase?.id, testCase.id);
      expect(controller.targetMapLat, closeTo(testCase.lat, 0.0001));
      expect(controller.targetMapLng, closeTo(testCase.lng, 0.0001));
      expect(controller.mapMoveCounter, greaterThan(initialCounter));
      expect(controller.selectedLawyer, isNull);
    });

    test('Selección de abogado en mapa enfoca sus coordenadas', () {
      final initialCounter = controller.mapMoveCounter;
      final lawyer = controller.allLawyers.first;

      controller.selectLawyer(lawyer);

      expect(controller.selectedLawyer?.id, lawyer.id);
      expect(controller.targetMapLat, closeTo(lawyer.lat, 0.0001));
      expect(controller.targetMapLng, closeTo(lawyer.lng, 0.0001));
      expect(controller.mapMoveCounter, greaterThan(initialCounter));
    });

    test('simulateIncomingDriverAlert() genera nuevo caso, activa alerta y centra mapa', () {
      final initialCaseCount = controller.allCases.length;
      final initialCounter = controller.mapMoveCounter;

      controller.simulateIncomingDriverAlert();

      expect(controller.allCases.length, initialCaseCount + 1);
      final newCase = controller.allCases.first;
      expect(controller.selectedCase?.id, newCase.id);
      expect(controller.lastAlertedCaseId, newCase.id);
      expect(controller.targetMapLat, closeTo(newCase.lat, 0.0001));
      expect(controller.targetMapLng, closeTo(newCase.lng, 0.0001));
      expect(controller.mapMoveCounter, greaterThan(initialCounter));
    });

    test('getAssignedLawyerForCase() resuelve la unidad móvil correcta', () {
      final caseWithLawyer = controller.allCases.firstWhere(
        (c) => c.abogadoAsignado != null && c.abogadoAsignado!.isNotEmpty,
      );

      final lawyer = controller.getAssignedLawyerForCase(caseWithLawyer);
      expect(lawyer, isNotNull);
      expect(caseWithLawyer.abogadoAsignado, contains(lawyer!.nombre));
      expect(lawyer.lat, isNotNull);
      expect(lawyer.lng, isNotNull);
    });

    test('Cálculo de Haversine para ETA entre siniestro y abogado asignado', () {
      final distKm = controller.calculateDistanceKm(0.2338, -78.2612, 0.2280, -78.2600);
      expect(distKm, greaterThan(0.0));
      expect(distKm, lessThan(2.0)); // Están en Otavalo a ~0.6-0.8 km
    });

    test('animateMapToCase() activa modo split si estaba en tableOnly', () {
      controller.setDispatchViewMode(LegalDispatchViewMode.tableOnly);
      expect(controller.dispatchViewMode, LegalDispatchViewMode.tableOnly);

      final testCase = controller.allCases.first;
      controller.animateMapToCase(testCase);

      expect(controller.dispatchViewMode, LegalDispatchViewMode.split);
      expect(controller.selectedCase?.id, testCase.id);
      expect(controller.targetMapLat, closeTo(testCase.lat, 0.0001));
    });

    testWidgets('LegalRealtimeTable se renderiza sin desbordamientos en pantalla móvil ultra compacta (320px)', (tester) async {
      Get.put(controller);
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LegalRealtimeTable(isSplitView: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LegalRealtimeTable), findsOneWidget);
      expect(find.text('Mapa'), findsWidgets);
      expect(find.text('Expediente'), findsWidgets);
    });

    testWidgets('LegalRealtimeTable se renderiza fluidamente en smartphone estándar (390px)', (tester) async {
      Get.put(controller);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LegalRealtimeTable(isSplitView: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LegalRealtimeTable), findsOneWidget);
    });

    testWidgets('LegalRealtimeTable se adapta en phablet / pantalla grande (430px)', (tester) async {
      Get.put(controller);
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: LegalRealtimeTable(isSplitView: true),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LegalRealtimeTable), findsOneWidget);
    });
  });
}

