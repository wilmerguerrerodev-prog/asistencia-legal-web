import 'package:flutter/cupertino.dart';
import 'package:getdash/data/model/response/language_model.dart';
import 'package:getdash/utils/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({required BuildContext context}) {
    return AppConstants.languages;
  }
}
