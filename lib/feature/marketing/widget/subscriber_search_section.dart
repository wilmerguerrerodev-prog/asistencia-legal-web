import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/custom_text_field.dart';
import 'package:getdash/utils/dimensions.dart';

class SubscriberSearchSection extends StatelessWidget {
  const SubscriberSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
            ),
            child: CustomTextField(
              hintText: 'search'.tr,
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeLarge),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
          ),
          child: IntrinsicHeight(
            child: Row(children: [
              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeRadius),child: const Text("Export As")),
              VerticalDivider(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),thickness: 2),
              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeRadius),child: CustomButton(buttonText: "Excel",width: 40,fontSize: Dimensions.fontSizeExtraSmall)),
              VerticalDivider(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),thickness: 2),
              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeRadius),child: CustomButton(buttonText: "CSV",width: 40,fontSize: Dimensions.fontSizeExtraSmall)),
              VerticalDivider(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),thickness: 2),
              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeRadius),child: CustomButton(buttonText: "PDF",width: 40,fontSize: Dimensions.fontSizeExtraSmall)),
            ]),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeLarge),
        CustomButton(
          width: 144,
          height: 60,
          icon: Icons.search,
          buttonText: 'Search',
          onPressed: (){
            if (kDebugMode) {
              print("search Users Pressed");
            }
          },
        ),
      ],
    );
  }
}
