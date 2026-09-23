import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class ChartHeader extends StatelessWidget {
  final String? title;
  const ChartHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title!,style: ubuntuMedium.copyWith(fontSize: 20,color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .7))),
              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge)]));
  }
}
