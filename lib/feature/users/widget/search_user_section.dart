import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class SearchSection extends StatelessWidget {
  final double screenWidth;
  const SearchSection({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {


    return SizedBox(
      height: Dimensions.paddingSizeDoubleExtraLarge,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimensions.paddingSizeExtraSmall)),
              ),
              child: CustomTextField(
                hintText: 'search'.tr,
                suffixIcon: Image.asset(Images.search,color: Theme.of(context).textTheme.bodySmall!.color,),
              ),
            ),
          ),

          if(ResponsiveHelper.isDesktop(context))
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          if(ResponsiveHelper.isDesktop(context))
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: .25),
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
            ),
            height: 45,
            width: 150,
            child:  Align(
              alignment: Alignment.center,
              child: Text('search'.tr,
                style: ubuntuMedium.copyWith(
                  color: Get.isDarkMode ? Theme.of(context).textTheme.bodySmall!.color : Theme.of(context).primaryColor,
                ),),
            ),
          ),
        ],
      ),
    );

  }
}
