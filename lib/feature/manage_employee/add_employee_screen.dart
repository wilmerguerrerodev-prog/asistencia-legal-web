import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/manage_employee/widget/employee_upload_file_section.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    String selectedDuration = 'Select Role';

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
                                      CommonHeader(title: "add_employee".tr),
                                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                      SizedBox(
                                        width: screenWidth / 2.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const EmployeeUploadFileSection(),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('first_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_first_name".tr),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('last_name'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_first_name".tr),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('phone_number'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(
                                              hintText: 'enter_phone_number'.tr,
                                              inputType: TextInputType.phone,
                                              onValidate: (String? value){
                                                return GetUtils.isPhoneNumber(value!) ? null:'enter_phone_number'.tr;
                                              },
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('email_address'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_email_address".tr),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('password'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_password".tr),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text('confirm_password'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_confirm_password".tr),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                            Text("role".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                            const SizedBox(height: Dimensions.paddingSizeSmall),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),),
                                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  value: selectedDuration,
                                                  items: <String>['Select Role', 'B', 'C', 'D'].map((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value,style: ubuntuRegular.copyWith(
                                                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
                                                          fontSize: Dimensions.fontSizeSmall),),);}).toList(),
                                                  onChanged: (value) {
                                                    selectedDuration = value!;
                                                  },),
                                              ),
                                            ),
                                            const SizedBox(height: Dimensions.paddingSizeLargeThirty),
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

