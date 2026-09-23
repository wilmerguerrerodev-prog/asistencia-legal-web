import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';

class UltimateCard1 extends StatelessWidget {
  const UltimateCard1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Images.natureimg1,
              scale: 3,
              fit: BoxFit.fitWidth,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                const Text("17k"),
                const SizedBox(
                  width: 3,
                ),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                const Text("75"),
              ],
            ),
            Text(
              "The Ultimate Glossary Of Terms About",
              style: TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              "There are many various of passage of majority have suffered alternation in some form.",
              style: TextStyle(fontSize: Dimensions.fontSizeDefault),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      Images.miclebolt,
                      scale: 4,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Michel Bold",
                      style: TextStyle(fontSize: Dimensions.fontSizeDefault),
                    ),
                  ],
                ),
                Text(
                  "15 December 2023",
                  style: TextStyle(fontSize: Dimensions.fontSizeDefault),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
