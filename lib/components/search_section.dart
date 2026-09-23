import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/core/helper/help_me.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';

class SearchSection extends StatelessWidget {
  final double screenWidth;
  final bool isActiveFilterBtn;
  const SearchSection({Key? key, required this.screenWidth, required this.isActiveFilterBtn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedDuration = 'Filter By Status';

    return SizedBox(
      height: Dimensions.paddingSizeDoubleExtraLarge,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
              ),
              child: CustomTextField(
                hintText: 'search'.tr,
              ),
            ),
          ),

          if(isActiveFilterBtn)
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          if(isActiveFilterBtn)

          Container(
            height: Dimensions.textFieldSize,
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
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                value: selectedDuration,
                items: <String>['Filter By Status', 'B', 'C', 'D'].map((String value) {
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

          if(ResponsiveHelper.isDesktop(context))
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          if(ResponsiveHelper.isDesktop(context))
          CustomButton(
            width: 144,
            height: Dimensions.textFieldSize,
            radius: Dimensions.radiusSmall,
            buttonText: 'search'.tr,
            onPressed: (){
              printLog("search Users Pressed");

            },
          )


        ],
      ),
    );

  }
}
