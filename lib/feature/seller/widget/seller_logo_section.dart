import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SellerLogoSection extends StatelessWidget {
  const SellerLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("seller_information".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),

        if(ResponsiveHelper.isMobile(context))
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: Text('seller_logo'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
          ),

        Row(
          children: [
            Container(
                height: Dimensions.uploadFileSize,
                width: Dimensions.uploadFileSize,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                  padding: EdgeInsets.zero,
                  radius: const Radius.circular(20),dashPattern: const [8,4],

                  child:  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Icon(
                      Icons.cloud_upload,
                      size: Dimensions.iconSizeMedium,
                      color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text("upload_file".tr,style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5)),),
                  ])),
                )),
            const SizedBox(width: Dimensions.paddingSizeDefault,),
            if(!ResponsiveHelper.isMobile(context))
              Text("seller_logo".tr, style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5),),)
          ],
        ),
      ],);
  }
}
