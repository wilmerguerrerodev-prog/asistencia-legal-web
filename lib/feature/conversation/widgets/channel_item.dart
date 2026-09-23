import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/gaps.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class ChannelItem extends StatelessWidget {
  final String channelupdatedAt;
  final int isRead;
  final int index;
  const ChannelItem({Key? key, required this.channelupdatedAt, required this.isRead, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: index == 0 ? Theme.of(context).colorScheme.primary.withOpacity(.2):Theme.of(context).hoverColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          const SizedBox(width: Dimensions.paddingSizeSmall,),
          ClipRRect(borderRadius: BorderRadius.circular(50),
            child: Image.asset(
                Images.profileImageOne,
                height: 40,
                width: 40,
            ),
          ),
          Gaps.horizontalGapOf(Dimensions.paddingSizeSmall),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mr. First Name",
                    style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color:Theme.of(context).textTheme.bodySmall!.color,
                    )
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),
                  Text(
                    'Customer',
                    style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color:Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.6) ),),
                ],
              )
          ),
          Text(channelupdatedAt,
              textDirection: TextDirection.ltr,
              style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeExtraSmall,
                color:Theme.of(context).textTheme.bodySmall!.color)),

          const SizedBox(width: Dimensions.paddingSizeSmall,),
        ],
      ),
    );
  }
}

