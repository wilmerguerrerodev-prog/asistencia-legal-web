import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/localization_controller.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/language/widgets/language_widget.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class ChooseLanguageDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final Function()? onYesPressed;
  final bool? isLogOut;
  final Function? onNoPressed;
  final Widget? widget;
  const ChooseLanguageDialog({super.key, this.title, @required this.description, @required this.onYesPressed,
    this.isLogOut = false, this.onNoPressed, this.widget});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizationController){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          insetPadding: const EdgeInsets.all(30),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: SizedBox(width: 500, child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: widget ?? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
              title != null ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  title!, textAlign: TextAlign.center,
                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
                ),
              ) : const SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                child: Text(description!, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  childAspectRatio: 2,
                ),
                itemCount: localizationController.languages.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => LanguageWidget(
                  languageModel: localizationController.languages[index],
                  localizationController: localizationController, index: index,
                ),
              ),
            ]),
          )),
        );
      },
    );
  }
}
