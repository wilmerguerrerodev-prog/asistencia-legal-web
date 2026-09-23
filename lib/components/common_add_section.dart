import 'package:flutter/material.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import 'package:get/get.dart';

class CommonAddSection extends StatelessWidget {
  final String title;
  final String addBtnTitle;
  final bool isBtnActive;
  final String navigationPage;
  const CommonAddSection({super.key, required this.title, this.isBtnActive = true, this.navigationPage = '', this.addBtnTitle = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        decoration: BoxDecoration(
            border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
            ),
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: ubuntuMedium.copyWith(fontSize: 20)),
              if(isBtnActive)
              CustomButton(
                width: 144,
                buttonText: addBtnTitle,
                fontSize: Dimensions.fontSizeSmall,
                onPressed: (){
                  Get.toNamed(navigationPage);
                },
              )
            ],
          ),
        )
    );
  }
}
