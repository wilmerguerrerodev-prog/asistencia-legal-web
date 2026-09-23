import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class UploadImageSection extends StatelessWidget {
  const UploadImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload Image",style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5))),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: DottedBorder(borderType: BorderType.RRect,color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),padding: EdgeInsets.zero,radius: const Radius.circular(Dimensions.radiusDefault),dashPattern: const [8,4],
                  child:  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Icon(
                      Icons.cloud_upload,
                      size: Dimensions.iconSizeMedium,
                      color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text("Upload File",style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5)),),
                  ])),
                )),
          ],),
        const SizedBox(width: Dimensions.paddingSizeDefault,),
        SizedBox(
            width: 220,
            child:  Text("Image format -  jpg, png, jpeg, gif Image Size -  maximum size 2 MB Image Ratio - 1:1",
              style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.5),),))

      ],
    );
  }
}
