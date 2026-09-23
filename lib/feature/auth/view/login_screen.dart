import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/choose_language_dialog.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        body: SafeArea(
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
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraMoreLarge,horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("welcome_back".tr,style: ubuntuBold.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall!.color!,
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                Text("please_enter_your_details_to_sign_in".tr,
                                style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),),),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                Text("email".tr,style: ubuntuMedium.copyWith(
                                    color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                                    fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                CustomTextField(
                                  hintText: "enter_your_email".tr,
                                  suffixIcon: Image.asset(Images.email,scale: 3,),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                Text("password".tr,style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5), fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(height: Dimensions.paddingSizeSmall),
                                CustomTextField(
                                  hintText: "enter_password".tr,
                                  suffixIcon: Image.asset(Images.password,scale: 3,),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        onTap: () {},
                                        title: Row(
                                          children: [
                                            SizedBox(width: 20.0,
                                              child: Checkbox(
                                                activeColor: Theme.of(context).primaryColor,
                                                value: false,
                                                onChanged: (bool? isChecked) {
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                            Text(
                                              'remember_me'.tr,
                                              style: ubuntuRegular.copyWith(
                                                  color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                                                  fontSize: Dimensions.fontSizeSmall),
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        horizontalTitleGap: 0,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                                        child: Text('forgot_password'.tr, style: ubuntuRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),

                                CustomButton(
                                    buttonText: "login".tr,
                                    onPressed: (){}),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Container(
                                  height: Dimensions.buttonSize,
                                  decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
                                  ),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(Images.google,scale: 3,),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text('login_with_google'.tr)
                                ],
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                              Text("don't_have_an_account".tr,style: ubuntuRegular.copyWith(
                                color:  Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),
                              ),),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Text("sign_up".tr,style: ubuntuRegular.copyWith(
                                color:  Theme.of(context).textTheme.bodyMedium!.color!,
                              ),),
                            ]),
                          ])),
                    ]),
                ))));
  }
}
