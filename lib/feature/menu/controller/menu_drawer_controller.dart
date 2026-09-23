import 'package:get/get.dart';

class MenuDrawerController extends GetxController implements GetxService {
  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  String _subMenuSelectedTitle = '';
  String get subMenuSelectedTitle => _subMenuSelectedTitle;

  bool _isMenuDrawerExpanded = true;
  bool get isMenuDrawerExpanded => _isMenuDrawerExpanded;


  void toggleMenuDrawer(){
    _isMenuDrawerExpanded = !_isMenuDrawerExpanded;
    update();
  }

  void updateSelectedIndex(int index){
    _selectedIndex = index;
    update();
  }
  void updateSubMenuSelectedIndex(String title){
    _subMenuSelectedTitle = title;
    update();
  }

}