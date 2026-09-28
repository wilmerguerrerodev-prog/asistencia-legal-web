import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/feature/legal_center/controller/legal_center_controller.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    // Auth & RBAC
    Get.put(AuthMockController(), permanent: true);

    // LegalCenterController permanente para retención de estado en cambio de roles y modos
    Get.put(LegalCenterController(), permanent: true);

    // Common controllers
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => MenuDrawerController());
  }
}
