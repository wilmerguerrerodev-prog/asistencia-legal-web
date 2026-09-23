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


class SmsOtpSettingScreen extends StatelessWidget {
  const SmsOtpSettingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    String selectedDuration = 'Select Payment Gateway';
    return Scaffold(
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraMoreLarge,
                            horizontal: Dimensions.paddingSizeDefault),
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
                                    CommonHeader(title: "sms_gateway_setup".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    SizedBox(
                                      width:ResponsiveHelper.isMobile(context)?screenWidth :screenWidth / 1.6,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                              child: DropdownButton<String>(
                                                isExpanded: true,
                                                underline: const SizedBox(),
                                                value: selectedDuration,
                                                items: <String>['Select Payment Gateway', 'B', 'C', 'D'].map((String value) {
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
                                            const Divider(),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                       Expanded(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                                            Text("provide_releans_setup_info".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                                            const SizedBox(height: Dimensions.paddingSizeLarge),
                                                            Text(
                                                              "Releans is a global leader in customer engagement, prowering a brod range of communication channels to reach.",
                                                              style: ubuntuRegular.copyWith(
                                                                  fontSize: Dimensions.fontSizeDefault,
                                                                color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)
                                                              ),)
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: Dimensions.paddingSizeLarge,),
                                                      if(ResponsiveHelper.isDesktop(context))
                                                      selectPaymentInfo(screenWidth,context),
                                                    ],
                                                  ),
                                                  if(ResponsiveHelper.isMobile(context))
                                                  selectPaymentInfo(screenWidth,context),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectPaymentInfo(screenWidth,context){
    return SizedBox(
      width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
          Text('api_key'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
          const SizedBox(height: Dimensions.paddingSizeSmall,),
          CustomTextField(hintText: "api_key".tr),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text('from'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
          const SizedBox(height: Dimensions.paddingSizeSmall,),
          CustomTextField(hintText: "from".tr),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Text('otp_template'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
          const SizedBox(height: Dimensions.paddingSizeSmall,),
          CustomTextField(
            hintText: 'otp_template'.tr,
          ),
          const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(buttonText: "reset".tr,width: 90,height: Dimensions.buttonSize, fontSize: Dimensions.fontSizeSmall),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                CustomButton(
                    buttonText: "submit".tr,
                    fontSize: Dimensions.fontSizeSmall,
                    height:Dimensions.buttonSize,
                    width: 90,
                    onPressed: () {}),]
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

        ],
      ),
    );
  }
}

