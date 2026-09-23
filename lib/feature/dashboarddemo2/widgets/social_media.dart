import 'package:d_chart/single_bar/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SocialMediaTraffic extends StatelessWidget {
  const SocialMediaTraffic({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;
    return Container(
      height: 300,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Social Media",
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),

            Row(
              children: [
                Text("Facebook ",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.blue,
                        value: 80,
                        max: 100)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text("45,567",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                Text("Instagram",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.green,
                        value: 60,
                        max: 100)),
                SizedBox(
                  width: screenWidth / 15,
                ),
                Text("15,678",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                Text("WhatsApp",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.purple,
                        value: 80,
                        max: 100)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text("17,786",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                Text("Twitter      ",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.blueGrey,
                        value: 40,
                        max: 100)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text("45,567",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                Text("YouTube   ",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.green,
                        value: 70,
                        max: 100)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text("12,654",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),
            Row(
              children: [
                Text("LinkedIn    ",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                SizedBox(
                    height: 10,
                    width: 200,
                    child: DChartSingleBar(
                        radius: BorderRadius.circular(30),
                        foregroundColor: Colors.black,
                        value: 30,
                        max: 100)),
                const SizedBox(width: Dimensions.paddingSizeDefault),
                Text("12,453",
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
