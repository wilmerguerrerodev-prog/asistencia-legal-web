import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/widgets/dispatch_lawyer_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LegalCenterController controller;

  setUp(() {
    Get.reset();
    controller = LegalCenterController();
    controller.onInit();
    Get.put(controller);
  });

  group('DispatchLawyerDialog - Responsividad y Prevención de Overflows', () {
    testWidgets('Renderiza sin overflow en pantalla móvil ultra compacta (320px)', (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(find.text('Despachar Abogado Móvil'), findsOneWidget);
      expect(find.text('Grupo Ecuador Total Abogados'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renderiza sin overflow en teléfono físico del usuario (360px)', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(find.text('Despachar Ahora'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renderiza sin overflow en smartphone moderno (390px)', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renderiza correctamente en pantalla grande/web (800px)', (tester) async {
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(find.text('Confirmar Despacho'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renderiza sin overflow en pantalla ultra estrecha / pantalla cover plegable (280px)', (tester) async {
      tester.view.physicalSize = const Size(280, 653);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renderiza sin overflow en modo apaisado / landscape con altura reducida (340px altura)', (tester) async {
      tester.view.physicalSize = const Size(720, 340);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final caseItem = controller.allCases.first;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: DispatchLawyerDialog(caseItem: caseItem),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DispatchLawyerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
