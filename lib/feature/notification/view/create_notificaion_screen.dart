import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/upload_file_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class CreateNotificationScreen extends StatelessWidget {
  const CreateNotificationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Please Select';
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
                                      CommonHeader(title: "create_notification".tr),
                                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                      SizedBox(
                                        width: screenWidth / 2.5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            UploadFileSection(title: 'upload_cover_image'.tr,),
                                            const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                            Text('title'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(hintText: "enter_notification_title".tr),
                                            const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                            Text('description'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            CustomTextField(
                                                maxLines: 4,
                                                hintText: "enter_your_description".tr),
                                            const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                            Text('select_receiver'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                            _commonSelectDropDown(selectedDuration,context),
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


  Widget _commonSelectDropDown(selectedDuration,context,){
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('please_select'.tr,),
          underline: const SizedBox(),
          value: selectedDuration,
          items: <String>['Please Select', 'B', 'C', 'D'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,style: ubuntuRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),);}).toList(),
          onChanged: (value) {
            selectedDuration = value!;
          },),
      ),
    );
  }
}

