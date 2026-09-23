import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';


class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    String selectedDuration = 'Please Select';
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
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeExtraMoreLarge,
                            horizontal: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall:Dimensions.paddingSizeLarge),
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
                                    CommonHeader(title: "add_new_product".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    Text("You need to at least 4 images.Pay Attention to the quality of the pictures you add, "
                                        "comply with the backgrounds color standards. Pictures must be in certain dimensions.  ."
                                        " Pictures must be in certain dimensions.  You need to at least 4 images.Pay Attention to the"
                                        " quality of the pictures you add, comply with the backgrounds color standards. Pictures "
                                        "must be in certain dimensions.  . Pictures must be in certain dimensions.",
                                      style: ubuntuRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    SizedBox(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  // width: ResponsiveHelper.isDesktop(context) ? screenWidth / 3:screenWidth / 1.3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                    Text('product_name'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    CustomTextField(hintText: "enter_product_name".tr),
                                                    const SizedBox(height: Dimensions.paddingSizeLarge),
                                                    Text("store".tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                                    _commonSelectDropDown(selectedDuration,context),
                                                   const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                                    Text('category'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    _commonSelectDropDown(selectedDuration,context),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                                    Text('brands'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    _commonSelectDropDown(selectedDuration,context),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                                    Text('product_price'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    CustomTextField(hintText: "enter_product_price".tr),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                                    Text('product_discount'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    CustomTextField(hintText: "enter_confirm_password".tr),
                                                      const SizedBox(height: Dimensions.paddingSizeLargeThirty),
                                                
                                                    Text('description'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    CustomTextField(
                                                        maxLines: 6,
                                                        hintText: "enter_product_description".tr),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                                      Text('do_not_over_100_character'.tr,
                                                        style: ubuntuRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),
                                                      ),
                                                  ],),
                                                ),
                                              ),
                                              if(ResponsiveHelper.isDesktop(context))
                                              const SizedBox(width: Dimensions.paddingSizeExtraMoreLarge,),
                                              if(ResponsiveHelper.isDesktop(context))
                                              SizedBox(
                                                width:screenWidth / 3,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('product_images'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        _productImageWidget(context,230.0,screenWidth/6),
                                                        const SizedBox(width: Dimensions.paddingSizeLarge,),
                                                        Column(
                                                          children: [
                                                            _productImageWidget(context,105.0,screenWidth/7.5),
                                                            const SizedBox(height: Dimensions.paddingSizeLarge,),
                                                            _productImageWidget(context,105.0,screenWidth/7.5),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    Text("You need to at least 4 images.Pay Attention to the quality of the pictures you add,"
                                                        " comply with the backgrounds color standards." ,
                                                      style: ubuntuRegular.copyWith(
                                                          fontSize: Dimensions.fontSizeDefault,
                                                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                                    Text('product_date'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    _commonSelectDropDown(selectedDuration,context),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                                    Text('add_size'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    _commonSelectDropDown(selectedDuration,context),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    SizedBox(
                                                      width: 400,
                                                      child: Wrap(
                                                        children: [
                                                          _selectedSizeWidget("EU-40.5",context),
                                                          _selectedSizeWidget("EU-38.5",context),
                                                          _selectedSizeWidget("EU-41.5",context),
                                                          _selectedSizeWidget("EU-41.5",context),
                                                          _selectedSizeWidget("EU-41.5",context),
                                                          _selectedSizeWidget("EU-41.5",context),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                                    Text('meta_title'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    CustomTextField(hintText: "please_add_meta_title_here".tr),
                                                    const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                                    Text('meta_image'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                    _productImageWidget(context,105.0,200),
                                                    const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: CustomButton(
                                                            height: 50,
                                                              onPressed: (){
                                                              },
                                                              buttonText: 'add_product'.tr),
                                                        ),
                                                        const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                        Expanded(
                                                          child: Container(
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Theme.of(context).primaryColor)
                                                            ),
                                                            child: Center(child: Text("save_product".tr)),
                                                          ),
                                                        )

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if(!ResponsiveHelper.isDesktop(context))
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('product_images'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _productImageWidget(context,230.0,screenWidth/3),
                                                  const SizedBox(width: Dimensions.paddingSizeLarge,),
                                                  Column(
                                                    children: [
                                                      _productImageWidget(context,105.0,screenWidth/3.5),
                                                      const SizedBox(height: Dimensions.paddingSizeLarge,),
                                                      _productImageWidget(context,105.0,screenWidth/3.5),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              Text("You need to at least 4 images.Pay Attention to the quality of the pictures you add,"
                                                  " comply with the backgrounds color standards." ,
                                                style: ubuntuRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeDefault,
                                                    color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                              const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                              Text('product_date'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              _commonSelectDropDown(selectedDuration,context),
                                              const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                              Text('add_size'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              _commonSelectDropDown(selectedDuration,context),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              SizedBox(
                                                width: 400,
                                                child: Wrap(
                                                  children: [
                                                    _selectedSizeWidget("EU-40.5",context),
                                                    _selectedSizeWidget("EU-38.5",context),
                                                    _selectedSizeWidget("EU-41.5",context),
                                                    _selectedSizeWidget("EU-41.5",context),
                                                    _selectedSizeWidget("EU-41.5",context),
                                                    _selectedSizeWidget("EU-41.5",context),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                              Text('meta_title'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              CustomTextField(hintText: "please_add_meta_title_here".tr),
                                              const SizedBox(height: Dimensions.paddingSizeLargeThirty,),
                                              Text('meta_image'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              _productImageWidget(context,105.0,screenWidth/1.2),
                                              const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomButton(
                                                        height: 50,
                                                        onPressed: (){
                                                        },
                                                        buttonText: 'add_product'.tr),
                                                  ),
                                                  const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                  Expanded(
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Theme.of(context).primaryColor)
                                                      ),
                                                      child: Center(child: Text("save_product".tr)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
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

  Widget _productImageWidget(context,height,width){
    return  Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.05),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
          padding: EdgeInsets.zero,
          radius: const Radius.circular(10),dashPattern: const [8,4],
          child:  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Image.asset(
              Images.thumbnail,
              scale: 3,
              color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text("upload_file".tr,style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
          ])),
        ));
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

  Widget _selectedSizeWidget(String title,context){
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.06)),
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimensions.paddingSizeMint,
              horizontal: Dimensions.paddingSizeLarge),
          child: Text("EU-38.5",style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color:Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
        ),
      ),
    );
  }
  
}

