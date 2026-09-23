import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class UploadFileSection extends StatelessWidget {
  final String title;
  const UploadFileSection({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Text(title,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
        ),

        Row(
          children: [
            Container(
                height: Dimensions.uploadFileSize,
                width: Dimensions.uploadFileSize,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
                  padding: EdgeInsets.zero,
                  radius: const Radius.circular(20),dashPattern: const [8,4],

                  child:  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Icon(
                      Icons.cloud_upload,
                      size: Dimensions.iconSizeMedium,
                      color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Text("upload_file".tr,style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                  ])),
                )),
            const SizedBox(width: Dimensions.paddingSizeDefault,),

          ],
        ),
      ],);
  }
}
