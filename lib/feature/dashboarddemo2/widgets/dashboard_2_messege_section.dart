import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class MessegeSection extends StatelessWidget {
  const MessegeSection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenWidth / 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Search for Products made just for you",
                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, fontWeight: FontWeight.bold)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Text("There are many variations of passage of lorem ipsum available, to the majority have suffered passage of lorem ipsum",
                      style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,),),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF092191),
                          borderRadius: BorderRadius.circular(10)),
                      child:  Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Text(
                          "Entry to Get",
                          style: ubuntuRegular.copyWith(color: Theme.of(context).cardColor),
                        ),
                      ),
                    ),

                  ]),
            ),
            Image.asset(
              Images.dashboardmainphoto,
              scale: ResponsiveHelper.isMobile(context) ? 5 : 4,
            )
          ],
        ),
      ),
    );
  }
}
