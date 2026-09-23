import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class MediaLibraryHeader extends StatelessWidget {
  final String? title;
  const MediaLibraryHeader({super.key,@required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 85,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title!,style: ubuntuMedium.copyWith(fontSize: 20,color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.7))),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Text("2422 image assets",style: ubuntuMedium.copyWith(fontSize: 16,color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.7))),
                    ],
                  ),
                  SizedBox(width: ResponsiveHelper.isDesktop(context)?  Get.width/4: Dimensions.paddingSizeLarge,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
                        ),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Dimensions.paddingSizeExtraSmall)),
                      ),
                      child: CustomTextField(
                        hintText: 'search'.tr,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),
                  CustomButton(
                    buttonText: 'add_new_media'.tr,
                    fontSize: Dimensions.fontSizeSmall,
                    width: 130,
                    height: 52,
                    onPressed: (){
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge)])));
  }
}
