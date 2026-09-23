import 'package:flutter/material.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class AddMediaLibrarySection extends StatelessWidget {
  const AddMediaLibrarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 95,
        decoration: BoxDecoration(
            border: Border.all(color:Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),
            ),
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Media Library",style: ubuntuBold.copyWith(fontSize: 20)),
              CustomButton(
                width: 144,
                icon: Icons.add,
                buttonText: 'Add Media',
                onPressed: (){
                },
              )
            ],
          ),
        )
    );
  }
}
