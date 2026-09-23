import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SmsTemplateScreen extends StatelessWidget {
  const SmsTemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ?  const WebMenuBar() : null,

        body: SafeArea(
            child: SizedBox(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: SingleChildScrollView(
                    child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                          CommonHeader(title: "sms_template".tr),
                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                          smsTemplateItem(title: "Email Confirmation", subTitle: "This template will be used for confirmation mail", context: context),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          smsTemplateItem(title: "Email Confirmation", subTitle: "This template will be used for confirmation mail", context: context),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          smsTemplateItem(title: "Email Confirmation", subTitle: "This template will be used for confirmation mail", context: context),
                        ],
                        )))))));
  }
}

Widget smsTemplateItem({
  required String title,
  required String subTitle,
  required BuildContext context}){

  return Container(
    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeRadius),
                Text(subTitle),
              ]),
          Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
                  ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))),
              child: const Center(child: Icon(Icons.edit))),
    ]),
  );
}
