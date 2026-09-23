import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/core/helper/help_me.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';


class FiltersSection extends StatelessWidget {
  final double screenWidth;
  const FiltersSection({Key? key, required this.screenWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'All';


    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:!ResponsiveHelper.isDesktop(context) ? MainAxisAlignment.start: MainAxisAlignment.spaceBetween,
          children: [
            filterItem('course'.tr, context,selectedDuration),
            if(ResponsiveHelper.isDesktop(context))
            filterItem('categories'.tr, context,selectedDuration),
            if(ResponsiveHelper.isDesktop(context))
              filterItem('organization'.tr, context,selectedDuration),
            if(ResponsiveHelper.isDesktop(context))
              const SizedBox(width: Dimensions.paddingSizeLarge,),
            if(ResponsiveHelper.isDesktop(context) && screenWidth > 1100)
              CustomButton(
              width: 144,
              height: 45,
              buttonText: 'submit'.tr,
              onPressed: (){
                printLog("search Users Pressed");
              },
            ),

          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault,),

        if(ResponsiveHelper.isDesktop(context) && screenWidth < 1100)
        CustomButton(
          width: 144,
          height: 45,
          buttonText: 'submit'.tr,
          onPressed: (){
            printLog("search Users Pressed");
          },
        ),


        if(ResponsiveHelper.isMobile(context))
          filterItem('organization'.tr, context,selectedDuration),
        const SizedBox(height: Dimensions.paddingSizeDefault,),
        if(ResponsiveHelper.isMobile(context))
        CustomButton(
          width: 144,
          height: 45,
          buttonText: 'submit'.tr,
          onPressed: (){
            printLog("search Users Pressed");
          },
        ),
      ],
    );

  }

  Widget filterItem(String title, BuildContext context,selectedDuration){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
        const SizedBox(width: Dimensions.paddingSizeSmall,),
        Container(
          width: ResponsiveHelper.isMobile(context) ? screenWidth / 2 :screenWidth/9,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.06),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraSmall
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox(),
              value: selectedDuration,
              items: <String>['All', 'B', 'C', 'D'].map((String value) {
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
        ),
      ],
    );
  }
}
