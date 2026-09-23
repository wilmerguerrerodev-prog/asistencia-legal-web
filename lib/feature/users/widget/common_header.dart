import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class CommonHeader extends StatelessWidget {
  final String? title;
  const CommonHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color:  Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),)
        ),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title!,style: ubuntuMedium.copyWith(fontSize: 20,color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .7))),
                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge)])));
  }
}
