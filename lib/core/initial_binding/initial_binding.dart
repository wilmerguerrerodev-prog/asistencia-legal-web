import 'package:get/get.dart';
import 'package:getdash/feature/language/controller/language_controller.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    //common controller
    Get.lazyPut(() => LanguageController());
    Get.lazyPut(() => MenuDrawerController());
  }
}
