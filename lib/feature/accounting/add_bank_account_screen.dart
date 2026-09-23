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


class AddBankAccountScreen extends StatelessWidget {
  const AddBankAccountScreen({super.key});


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
                                    CommonHeader(title: "add_bank_account".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    SizedBox(
                                      width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 2.5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                          Text('bank_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_bank_name".tr),



                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('bank_branch_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_bank_branch_name".tr),

                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('account_number'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(
                                            hintText: 'enter_account_number'.tr,
                                            inputType: TextInputType.phone,
                                            onValidate: (String? value){
                                              return GetUtils.isPhoneNumber(value!) ? null:'enter_phone_number'.tr;
                                            },
                                          ),


                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('account_holder_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_account_holder_name".tr),

                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('contact_number'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_contact_number".tr),


                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('initial_balance'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_initial_balance".tr),

                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('description'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(
                                            hintText: "enter_description".tr,
                                            maxLines: 4,
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
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
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

