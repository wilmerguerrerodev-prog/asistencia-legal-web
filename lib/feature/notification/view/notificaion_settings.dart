import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class NotificationSettingScreen extends StatelessWidget {
  const NotificationSettingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraMoreLarge,
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CommonHeader(title: "notification_setup".tr),
                                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                      SizedBox(
                                        width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 2.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                            Text('server_key'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_server_key".tr),
                                            const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomButton(
                                                      buttonText: "submit".tr,
                                                      fontSize: Dimensions.fontSizeSmall,
                                                      height:Dimensions.buttonSize,
                                                      width: 90,
                                                      onPressed: () {}),]
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),

                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                              const FooterSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

