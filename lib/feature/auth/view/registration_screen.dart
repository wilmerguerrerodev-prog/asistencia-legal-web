import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/choose_language_dialog.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        body: SafeArea(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraMoreLarge,horizontal: Dimensions.paddingSizeLarge),
                      child: Column(children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Text("get_dash".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          MenuButtonWebIcon(icon: Images.globe, onTap: () {

                            if (Get.isSnackbarOpen) {
                              Get.back();
                            }
                            Get.dialog(ChooseLanguageDialog(
                              description: 'choose_a_language'.tr,
                              onYesPressed: () {
                              },
                            ));
                          },)
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                        Container(
                            width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 2,
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraMoreLarge,horizontal: Dimensions.paddingSizeExtraMoreMoreLarge),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                              Text("name".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              CustomTextField(hintText: "enter_your_name".tr),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                              Text("email".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              CustomTextField(
                                hintText: "enter_your_email".tr,
                                suffixIcon: Image.asset(Images.email,scale: 3,),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                              Text("password".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              CustomTextField(
                                hintText: "enter_password".tr,
                                suffixIcon: Image.asset(Images.password,scale: 3,),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Text("must_be_at_least_six_characters".tr,style: ubuntuRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.5),
                              ),),
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                              CustomButton(
                                  buttonText: "sign_up".tr,
                                  onPressed: (){Get.toNamed("Hello");}),
                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              Container(
                                height: Dimensions.buttonSize,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(Images.google,scale: 3,),
                                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                                    Text('sign_up_with_google'.tr)
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                              Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                Text("already_have_an_account".tr,style: ubuntuRegular.copyWith(
                                  color:  Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.5),
                                ),),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Text("login".tr,style: ubuntuRegular.copyWith(
                                  color:  Theme.of(context).primaryColor,
                                ),),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                              Column(
                                children: [
                                  Text("by_signing_up".tr,style: ubuntuRegular.copyWith(
                                    color:  Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.5),
                                  ),),
                                  const SizedBox(height: Dimensions.paddingSizeDefault),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("terms_of_service".tr,style: ubuntuRegular.copyWith(
                                        color:  Theme.of(context).primaryColor,
                                      ),),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                        child: Text('and'.tr),
                                      ),
                                      Text("privacy_policy".tr,style: ubuntuRegular.copyWith(
                                        color:  Theme.of(context).primaryColor,
                                      ),),
                                    ],
                                  ),
                                ],
                              ),




                            ])),

                      ]),

                    )))));
  }
}
