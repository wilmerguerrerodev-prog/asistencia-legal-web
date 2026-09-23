import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getdash/data/model/response/language_model.dart';
import 'package:getdash/utils/app_constants.dart';

class LanguageController extends GetxController {
  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  void setSelectIndex(int index) {
    _selectIndex = index;
    update();
  }

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;


  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
    }
  }
}
