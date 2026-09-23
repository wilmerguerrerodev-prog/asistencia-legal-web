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


class AddBlogScreen extends StatelessWidget {
  const AddBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    String selectedCategory = 'Select Category';
    String selectedStatus = 'Select Status';

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
                                    CommonHeader(title: "add_blog".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    SizedBox(
                                      width:ResponsiveHelper.isMobile(context) ? screenWidth:screenWidth / 2.5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          UploadFileSection(title: 'upload_image'.tr,),
                                          const SizedBox(height: Dimensions.paddingSizeDoubleDoubleExtraLarge),
                                          Text('blog_title'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_blog_title".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('category'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
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
                                                value: selectedCategory,
                                                items: <String>['Select Category', 'B', 'C', 'D'].map((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value,style: ubuntuRegular.copyWith(
                                                        color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
                                                        fontSize: Dimensions.fontSizeSmall),),);}).toList(),
                                                onChanged: (value) {
                                                  selectedCategory = value!;
                                                },),
                                            ),
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('slug'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_slug".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('status'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
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
                                                value: selectedStatus,
                                                items: <String>['Select Status', 'B', 'C', 'D'].map((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value,style: ubuntuRegular.copyWith(
                                                        color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6),
                                                        fontSize: Dimensions.fontSizeSmall),),);}).toList(),
                                                onChanged: (value) {
                                                  selectedStatus = value!;
                                                },),
                                            ),
                                          ),


                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('meta_keyword'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_meta_keyword".tr),

                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          Text('short_description'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                                          CustomTextField(hintText: "enter_short_description".tr),

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

