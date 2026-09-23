import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/media_library/widget/media_library_header.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';


class MediaLibraryScreen extends StatelessWidget {
   MediaLibraryScreen({super.key});

  final List<String> mediaImages = [Images.mediaImageOne, Images.mediaImageTwo, Images.mediaImageOne, Images.mediaImageTwo, Images.mediaImageThree,Images.mediaImageThree,Images.mediaImageOne, Images.mediaImageTwo, Images.mediaImageThree];


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
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
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeExtraLarge),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    MediaLibraryHeader(title: "media_library".tr),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: ListView.builder(
                                              itemCount: 9,
                                              shrinkWrap: true,
                                              itemBuilder: (context, i){
                                                return Padding(
                                                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Image.asset(mediaImages[i],scale: 3,),
                                                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text("A chair made by GetChairFirst",style: ubuntuMedium.copyWith(
                                                              fontSize: Dimensions.fontSizeDefault,
                                                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                                                            ),),
                                                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                                                            Text("Used 3 times",style: ubuntuMedium.copyWith(
                                                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
                                                                fontSize: Dimensions.fontSizeExtraSmall),),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                      const RotatedBox(
                                                          quarterTurns: 2,
                                                          child: Icon(Icons.more_horiz))
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                        if(ResponsiveHelper.isDesktop(context))
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Stack(
                                              alignment: AlignmentDirectional.bottomEnd,
                                              children: [
                                              Image.asset(Images.mediaLibraryDetails,width: screenWidth/2.5,),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).cardColor,
                                                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(Images.updateImage, scale: 3,),
                                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                            Text("update_image".tr)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).cardColor,
                                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(Images.delete, scale: 3,),
                                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                            Text("delete".tr,style: ubuntuRegular.copyWith(color: Colors.red),)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],),
                                            const SizedBox(height: Dimensions.paddingSizeDefault,),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(Images.file,scale: 4,),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                    const Text("Added on July 21, 2023"),
                                                  ],
                                                ),
                                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                Row(
                                                  children: [
                                                    Text("download_file".tr,style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor),),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                    Text('copy_link'.tr),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                    Text('more'.tr),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                                      ],
                                    ),
                                    if(! ResponsiveHelper.isDesktop(context))
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            children: [
                                              Image.asset(Images.mediaLibraryDetails,width: screenWidth/2.5,),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).cardColor,
                                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(Images.updateImage, scale: 3,),
                                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                            Text("update_image".tr)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: Dimensions.paddingSizeDefault,),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).cardColor,
                                                          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(Images.delete, scale: 3,),
                                                            const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                            Text("delete".tr,style: ubuntuRegular.copyWith(color: Colors.red),)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],),
                                          const SizedBox(height: Dimensions.paddingSizeDefault,),
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(Images.file,scale: 4,),
                                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                  const Text("Added on July 21, 2023"),
                                                ],
                                              ),
                                              const SizedBox(width: Dimensions.paddingSizeDefault,),
                                              Row(
                                                children: [
                                                  Text("download_file".tr,style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColor),),
                                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                  Text('copy_link'.tr),
                                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                                  Text('more'.tr),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
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

