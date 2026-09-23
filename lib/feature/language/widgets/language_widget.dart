import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/data/model/response/language_model.dart';
import 'package:getdash/utils/app_constants.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  const LanguageWidget({super.key,
    required this.languageModel,
    required this.localizationController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        localizationController.setSelectIndex(index);
        localizationController.setLanguage(Locale(
          AppConstants.languages[localizationController.selectedIndex].languageCode!,
          AppConstants.languages[localizationController.selectedIndex].countryCode,
        ));
        Get.back();
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          border:  localizationController.selectedIndex == index ? Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .2), width: 1) : null,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Center(child: Text(languageModel.languageName!, style: ubuntuRegular)),
      ),
    );
  }
}
