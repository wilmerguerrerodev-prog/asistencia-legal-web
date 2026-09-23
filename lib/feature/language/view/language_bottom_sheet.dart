import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/language/widgets/language_widget.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/gaps.dart';
import 'package:getdash/utils/styles.dart';

class ChooseLanguageBottomSheet extends StatelessWidget {
  const ChooseLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {



    return GetBuilder<LocalizationController>(
      builder: (localizationController){
        return Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Theme.of(context).cardColor,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gaps.verticalGapOf(Dimensions.paddingSizeExtraLarge),
                Text("select_language".tr,style: ubuntuMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeDefault),),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                    childAspectRatio: (1/1),
                  ),
                  itemCount: localizationController.languages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => LanguageWidget(
                    languageModel: localizationController.languages[index],
                    localizationController: localizationController, index: index,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                Gaps.verticalGapOf(Dimensions.paddingSizeExtraLarge),
              ],
            ),
            SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : 0),
          ]),
        );
      },
    );
  }
}
