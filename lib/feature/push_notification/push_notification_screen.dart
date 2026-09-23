import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/push_notification/widget/upload_image_section.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class PushNotificationScreen extends StatelessWidget {
  const PushNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ?  const WebMenuBar() : null,
        drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,

        body: SafeArea(
            child: SizedBox(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                        CommonHeader(title: "push_notification".tr),
                        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                        Text('create_notification'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        const Divider(color: Colors.black,thickness: 0.2),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        pushNotificationInputItem(title: "Title", context: context),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        pushNotificationInputItem(title: "Description", context: context),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        notificationFilterSectionItem(title: "Select Receiver", context: context),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          const UploadImageSection(),
                          CustomButton(buttonText: "Update".tr,width: 74, fontSize: Dimensions.fontSizeSmall),
                        ]),

    ]),

    ))))))

    ;
  }
}

Widget pushNotificationInputItem({
  required String title,
  required BuildContext context}){

  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

    Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
    const SizedBox(height: Dimensions.paddingSizeSmall),
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: CustomTextField(
        ),
      ),
    ),

  ]);
}

Widget notificationFilterSectionItem({
  required String title,
  required BuildContext context}){
  String selectedDuration = 'All';

  return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

    Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
    const SizedBox(height: Dimensions.paddingSizeSmall),
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: DropdownButton<String>(
          isExpanded: true,
          underline: const SizedBox(),
          value: selectedDuration,
          items: <String>['All', 'B', 'C', 'D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            selectedDuration = value!;
          },
        ),
      ),
    ),

  ]);
}

