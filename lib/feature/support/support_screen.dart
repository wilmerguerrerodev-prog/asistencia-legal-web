import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_image.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            vertical: Dimensions.paddingSizeExtraMoreLarge,
                            horizontal: Dimensions.paddingSizeLarge),
                        child:  Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: 85,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                    ),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('support'.tr,style: ubuntuMedium.copyWith(fontSize: 20,color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.7))),
                                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),

                                            ]))),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text("#204 - Status of some DZ,DL and XB Shipments Showing Delivered",
                                        style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                          color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.7),
                                        ),),
                                    ),
                                    if(!ResponsiveHelper.isMobile(context))
                                    Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                  ],
                                ),
                                if(ResponsiveHelper.isMobile(context))
                                  Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                             Row(
                                              children: [
                                                const ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                                  child:CustomImage(image: 'image',width: 71,height: 71,),),
                                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                Text("Harpreet Bhatoa",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                              ],
                                            ),
                                            if(!ResponsiveHelper.isMobile(context))
                                            Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        ),
                                        if(ResponsiveHelper.isMobile(context))
                                          Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                        Text("The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do?",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault,),
                                //second message card
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                                  child:CustomImage(image: 'image',width: 71,height: 71,),),
                                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                Text("Harpreet Bhatoa",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                              ],
                                            ),
                                            if(!ResponsiveHelper.isMobile(context))
                                            Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        ),
                                        if(ResponsiveHelper.isMobile(context))
                                          Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                         Text("The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do? The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do?",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Soni Shukla",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                            Text("Team Shyplite",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                            Text("+91-9643318580",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                                  child:CustomImage(image: 'image',width: 71,height: 71,),),
                                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                Text("Harpreet Bhatoa",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                              ],
                                            ),
                                            if(!ResponsiveHelper.isMobile(context))
                                              Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        ),
                                        if(ResponsiveHelper.isMobile(context))
                                        Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),

                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                        Text("The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do?",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                                  child:CustomImage(image: 'image',width: 71,height: 71,),),
                                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                Text("Harpreet Bhatoa",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                              ],
                                            ),
                                            if(!ResponsiveHelper.isMobile(context))
                                            Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        ),
                                        if(ResponsiveHelper.isMobile(context))
                                          Text("04/09/2020, 09:20 AM",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),

                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                        Text("The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do? The shipment With the AWB  126318028397  didn’t arrive still to this day,What can we do?",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),

                                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Soni Shukla",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                            Text("Team Shyplite",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                            Text("+91-9643318580",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeLarge,),
                                        const Divider(),
                                        const SizedBox(height: Dimensions.paddingSizeLarge,),
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("2 Attachment",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color)),
                                            Text('download_all'.tr,style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color)),
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeDefault,),
                                        Wrap(
                                          children: [
                                            _attachmentCard("Report - Chatto project.pdf",Images.pdf,context),
                                            const SizedBox(width: Dimensions.paddingSizeDefault,),
                                            _attachmentCard("Report - Final Design.pdf",Images.zipFile,context),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: Dimensions.paddingSizeDefault,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(.05),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                      border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),)
                                  ),
                                  child: CustomTextField(
                                    hintText: 'type_your_message_here'.tr,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                      child: SizedBox(
                                        width: 160,
                                        child: Row(
                                          children: [
                                            Icon(Icons.attach_file,color:Theme.of(context).textTheme.bodySmall!.color!),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                                            Container(
                                              width: 1,
                                              height: 20,
                                              color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
                                            ),
                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                            Container(
                                                width: 120,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                                ),
                                                child: Center(child: Text("Send",style: TextStyle(color: Theme.of(context).cardColor),))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault,),
                              ],
                            ),
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

  Widget _attachmentCard(String fileName, String filePath, context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeRadius)),
        ),
        child: Padding(
          padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              Image.asset(filePath, scale: 2,),
              const SizedBox(width: Dimensions.paddingSizeDefault,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fileName,style: ubuntuMedium),
                  Text("2.5 Mb",style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

