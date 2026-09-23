import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class UnreadMessageSection extends StatelessWidget {
  const UnreadMessageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
          Text("Hello, GetDash!",style: ubuntuBold.copyWith(fontSize: 20)),
          const SizedBox(height: 5),
          Row(children: [
            Text("you_have".tr),
            const SizedBox(width: 2),
            Text("new_notification".tr,style: const TextStyle(color: Colors.blue)),
          ]),
        ]),
      ),
    );
  }
}
