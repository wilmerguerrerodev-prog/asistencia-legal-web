import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/theme/dark_theme.dart';
import 'package:getdash/core/theme/light_theme.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/legal_center/view/legal_center_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LegalCenterScreen - Role Switch and View Mode Transition Stability', () {
    late AuthMockController authController;
    late LegalCenterController legalController;

    setUp(() async {
      Get.reset();
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      Get.put<ThemeController>(ThemeController(sharedPreferences: prefs));
      authController = Get.put<AuthMockController>(AuthMockController(), permanent: true);
      legalController = Get.put<LegalCenterController>(LegalCenterController(), permanent: true);
    });

    testWidgets('Mobile: Switches smoothly between Dividida, Tabla, and Mapa without null exception', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      authController.switchRole(UserRole.adminLawyer, navigate: false);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: light,
          darkTheme: dark,
          home: const LegalCenterScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 1. Switch to Tabla mode
      legalController.setDispatchViewMode(LegalDispatchViewMode.tableOnly);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 2. Switch to Mapa mode
      legalController.setDispatchViewMode(LegalDispatchViewMode.mapOnly);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 3. Switch to Split mode
      legalController.setDispatchViewMode(LegalDispatchViewMode.split);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 4. Role switch: associateLawyer
      authController.switchRole(UserRole.associateLawyer, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 5. Role switch: itAdmin
      authController.switchRole(UserRole.itAdmin, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 6. Role switch: back to adminLawyer
      authController.switchRole(UserRole.adminLawyer, navigate: false);
      legalController.update();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Allow snackbar timers to finish completely
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('Desktop: Switches between view modes and roles without grey screen or null error', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      authController.switchRole(UserRole.adminLawyer, navigate: false);

      await tester.pumpWidget(
        GetMaterialApp(
          theme: light,
          darkTheme: dark,
          home: const LegalCenterScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Switch view modes on desktop
      legalController.setDispatchViewMode(LegalDispatchViewMode.split);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      legalController.setDispatchViewMode(LegalDispatchViewMode.tableOnly);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      legalController.setDispatchViewMode(LegalDispatchViewMode.mapOnly);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Pump frames without pumpAndSettle
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    });
  });
}
