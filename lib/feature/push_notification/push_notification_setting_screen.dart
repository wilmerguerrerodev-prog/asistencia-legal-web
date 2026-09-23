import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class PushNotificationSettingScreen extends StatefulWidget {
  const PushNotificationSettingScreen({super.key});

  @override
  State<PushNotificationSettingScreen> createState() => _PushNotificationSettingScreenState();
}

class _PushNotificationSettingScreenState extends State<PushNotificationSettingScreen> {
  bool value1 = true;

  onChangedMethod(bool newValue1){
    setState(() {
      value1 = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: ResponsiveHelper.isDesktop(context) ?  const WebMenuBar() : null,

        body: SafeArea(
            child: SizedBox(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: SingleChildScrollView(
                    child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                          CommonHeader(title: "notification_settings".tr),
                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                          Text('notification_settings'.tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          const Divider(color: Colors.black,thickness: 0.2),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Row(children: [
                            Text("activation".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            CupertinoSwitch(trackColor: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),activeColor: Theme.of(context).primaryColor,value: value1, onChanged: (newValue){
                              onChangedMethod(newValue);
                            }),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          pushNotificationInputItem(title: "App ID", context: context),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          pushNotificationInputItem(title: "App Key", context: context),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          pushNotificationInputItem(title: "App Secret", context: context),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          pushNotificationInputItem(title: "App Cluster", context: context),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          const Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                            CustomButton(buttonText: "Update",width: 100),
                          ]),
    ])))))));
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
          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
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
