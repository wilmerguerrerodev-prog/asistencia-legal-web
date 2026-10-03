import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/model/legal_case_model.dart';
import 'package:getdash/feature/legal_center/widgets/expediente_360_panel.dart';
import 'package:getdash/feature/legal_center/widgets/legal_case_detail_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LegalCenterController controller;

  setUp(() {
    Get.reset();
    controller = LegalCenterController();
    Get.put<LegalCenterController>(controller);
    controller.onInit();
  });

  group('Piloto Ibarra y Categorías de Casos (Requerimientos 2 de Octubre)', () {
    test('Ibarra es la vista base predeterminada territorial y de mapa', () {
      expect(controller.selectedProvince, 'Imbabura');
      expect(controller.selectedCanton, 'Ibarra');
      expect(controller.targetMapLat, closeTo(0.3517, 0.01));
      expect(controller.targetMapLng, closeTo(-78.1223, 0.01));

      // Al resetear filtros, vuelve a Ibarra
      controller.selectProvince('Pichincha');
      controller.selectCanton('Quito');
      expect(controller.selectedCanton, 'Quito');

      controller.resetFilters();
      expect(controller.selectedProvince, 'Imbabura');
      expect(controller.selectedCanton, 'Ibarra');
      expect(controller.targetMapLat, closeTo(0.3517, 0.01));
      expect(controller.targetMapLng, closeTo(-78.1223, 0.01));
    });

    test('Accesos directos territoriales y cascada de cantones (Imbabura y Pichincha)', () {
      // 1. Selector rápido a Pichincha
      controller.selectProvincePichincha();
      expect(controller.selectedProvince, 'Pichincha');
      expect(controller.selectedCanton, 'Todos');
      expect(controller.availableCantons, containsAll(['Todos', 'Quito', 'Cayambe', 'Rumiñahui']));
      expect(controller.targetMapLat, closeTo(-0.1807, 0.01));

      // 2. Selector rápido a Imbabura (Toda la provincia)
      controller.selectProvinceImbaburaAll();
      expect(controller.selectedProvince, 'Imbabura');
      expect(controller.selectedCanton, 'Todos');
      expect(controller.availableCantons.first, 'Todos');
      expect(controller.availableCantons[1], 'Ibarra'); // Ibarra prioritario

      // 3. Selector rápido a Piloto Base Ibarra
      controller.selectPilotIbarra();
      expect(controller.selectedProvince, 'Imbabura');
      expect(controller.selectedCanton, 'Ibarra');
      expect(controller.targetMapLat, closeTo(0.3517, 0.01));
      expect(controller.targetMapLng, closeTo(-78.1223, 0.01));
    });

    test('Casos iniciales en Ibarra incluyen categoría "Otro problema" con prueba gratuita', () {
      final ibarraCases = controller.filteredCases;
      expect(ibarraCases.isNotEmpty, isTrue);

      // Debe existir caso con categoría "Otro problema"
      final otroProblemaCase = ibarraCases.firstWhere(
        (c) => c.isOtroProblema,
      );
      expect(otroProblemaCase.tipoAlerta, TipoAlertaCaso.otroProblema);
      expect(otroProblemaCase.esPruebaGratuita, isTrue);
      expect(otroProblemaCase.consultasGratuitasRestantes, 7);
      expect(otroProblemaCase.consultasGratuitasTotales, 10);
      expect(otroProblemaCase.planDetalleLabel, contains('7/10 consultas'));
      expect(otroProblemaCase.descripcionDetalladaCliente.isNotEmpty, isTrue);
    });

    test('Casos iniciales en Ibarra contienen las 4 categorías solicitadas', () {
      final allCases = controller.allCases;

      final hasOtroProblema = allCases.any((c) => c.tipoAlerta == TipoAlertaCaso.otroProblema);
      final hasAgresion = allCases.any((c) => c.tipoAlerta == TipoAlertaCaso.agresionFisica);
      final hasChoque = allCases.any((c) => c.tipoAlerta == TipoAlertaCaso.transitoChoque);
      final hasDanos = allCases.any((c) => c.tipoAlerta == TipoAlertaCaso.danosMateriales);

      expect(hasOtroProblema, isTrue, reason: 'Debe contener Otro problema');
      expect(hasAgresion, isTrue, reason: 'Debe contener Agresión física');
      expect(hasChoque, isTrue, reason: 'Debe contener Choque/Tránsito');
      expect(hasDanos, isTrue, reason: 'Debe contener Daños materiales');
    });

    test('Grupo Ecuador Total Abogados está registrado como entidad y se puede despachar', () {
      final corpLawyer = controller.allLawyers.firstWhere(
        (l) => l.nombre.contains('Grupo Ecuador Total'),
      );
      expect(corpLawyer, isNotNull);
      expect(corpLawyer.canton, 'Ibarra');

      final targetCase = controller.allCases.firstWhere((c) => c.estado == CaseStatus.pendiente);
      controller.dispatchToCorporateGroup(targetCase.id);

      expect(targetCase.estado, CaseStatus.abogadoDespachado);
      expect(targetCase.abogadoAsignado, 'Grupo Ecuador Total Abogados');
      expect(targetCase.despachoCorporativo, 'Grupo Ecuador Total Abogados');
      expect(targetCase.timeline.first.title, contains('Despacho Corporativo'));
    });

    test('focusCaseRoute() enfoca el punto medio y encuadre óptimo de la ruta GPS entre abogado y caso', () {
      final targetCase = controller.allCases.firstWhere((c) => c.estado == CaseStatus.pendiente);
      controller.dispatchToCorporateGroup(targetCase.id);

      final corpLawyer = controller.getAssignedLawyerForCase(targetCase);
      expect(corpLawyer, isNotNull);

      controller.focusCaseRoute(targetCase);

      final expectedMidLat = (targetCase.lat + corpLawyer!.lat) / 2;
      final expectedMidLng = (targetCase.lng + corpLawyer.lng) / 2;

      expect(controller.targetMapLat, closeTo(expectedMidLat, 0.001));
      expect(controller.targetMapLng, closeTo(expectedMidLng, 0.001));
      expect(controller.targetMapZoom, greaterThanOrEqualTo(11.0));
    });

    testWidgets('Expediente360Panel renderiza tarjeta de "Otro Problema" y contador de prueba gratuita', (tester) async {
      final otroProblemaCase = controller.allCases.firstWhere((c) => c.isOtroProblema);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Expediente360Panel(caseItem: otroProblemaCase),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verifica badge de 4 categorías
      expect(find.text(TipoAlertaCaso.otroProblema.label), findsWidgets);

      // Verifica tarjeta destacada Otro Problema
      expect(find.textContaining('Detalle de la Consulta Legal • "Otro Problema"'), findsOneWidget);
      expect(find.text(otroProblemaCase.descripcionDetalladaCliente), findsWidgets);

      // Verifica badge de prueba gratuita con contador
      expect(find.textContaining('Periodo de Prueba Gratuita (Piloto Ibarra)'), findsOneWidget);
      expect(find.textContaining('7 de 10 restantes'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('LegalCaseDetailDialog renderiza estado de prueba gratuita y categoría Otro Problema', (tester) async {
      final otroProblemaCase = controller.allCases.firstWhere((c) => c.isOtroProblema);

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => LegalCaseDetailDialog(caseItem: otroProblemaCase),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Debe mostrar diálogo y elementos del requerimiento
      expect(find.byType(LegalCaseDetailDialog), findsOneWidget);
      expect(find.text(TipoAlertaCaso.otroProblema.label), findsWidgets);
      expect(find.textContaining('Periodo de Prueba Gratuita (Piloto Ibarra)'), findsOneWidget);
      expect(find.textContaining('Detalle de la Consulta Legal • "Otro Problema"'), findsOneWidget);
    });
  });
}
