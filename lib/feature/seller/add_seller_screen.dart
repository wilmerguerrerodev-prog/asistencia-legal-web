import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/seller/widget/seller_logo_section.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class AddSellerScreen extends StatelessWidget {
  const AddSellerScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
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
                            vertical: Dimensions.paddingSizeLarge,
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
                                    CommonHeader(title: "add_seller".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    SizedBox(
                                      width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 2.5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SellerLogoSection(),
                                          const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                          Text('seller_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_seller_name".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('phone_number'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(
                                            hintText: 'enter_phone_number'.tr,
                                            inputType: TextInputType.phone,
                                            onValidate: (String? value){
                                              return GetUtils.isPhoneNumber(value!) ? null:'enter_phone_number'.tr;
                                            },
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('email_address'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_email_address".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('country'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_country_name".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('address_line'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(
                                              maxLines: 3,
                                              hintText: "enter_address_line".tr),
                                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                          Text("contact_person".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                          Text('full_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_full_name".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('designation'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: 'enter_designation'.tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('phone_number'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(
                                            hintText: 'enter_phone_number'.tr,
                                            inputType: TextInputType.phone,
                                            onValidate: (String? value){
                                              return GetUtils.isPhoneNumber(value!) ? null:'enter_phone_number'.tr;
                                            },
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('email_address'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_email_address".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),
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
}

