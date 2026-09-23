import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class SellerOverviewSection extends StatelessWidget {
  const SellerOverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

        organizationOverviewItem(
            context: context,
            height: 320,
            width: 140,
            leadingIcon: Icons.bar_chart_outlined,
            title: "Total Earning Amount",
            totalSellerAmount: 675856.00,
            iconSize: Dimensions.iconSize,
            titleFontSize: Dimensions.fontSizeLarge,
            sellerAmountFontSize: Dimensions.fontSizeForReview,
            sellerAmountPadding: Dimensions.paddingSizeDoubleDoubleExtraLarge,
            sellerAmountColor: const Color(0xff3F52E3),
            sign: "\$",
            sellerAmountHeight: 130.00
        ),

        const SizedBox(width: Dimensions.paddingSizeLarge),

        organizationOverviewItem(
            context: context,
            height: 320,
            width: 140,
            leadingIcon: Icons.bar_chart_outlined,
            title: "Total Earning Amount",
            totalSellerAmount: 576835.00,
            iconSize: Dimensions.iconSize,
            titleFontSize: Dimensions.fontSizeLarge,
            sellerAmountFontSize: Dimensions.fontSizeForReview,
            sellerAmountPadding: Dimensions.paddingSizeDoubleDoubleExtraLarge,
            sellerAmountColor: const Color(0xff24D6A5),
            sign: "\$",
            sellerAmountHeight: 130.00
        ),


      ]),

      Column(children: [

        Row(children: [

          organizationOverviewItem(
              context: context,
              height: 150,
              width: 140,
              leadingIcon: Icons.bar_chart_outlined,
              title: "Total Course",
              totalSellerAmount: 45.00,
              iconSize: Dimensions.iconSizeDefault,
              titleFontSize: Dimensions.fontSizeDefault,
              sellerAmountFontSize: Dimensions.fontSizeLarge,
              sellerAmountPadding: Dimensions.paddingSizeDoubleExtraLarge,
              sellerAmountColor: const Color(0xff3F52E3),
              sign: "+",
              sellerAmountHeight: Dimensions.paddingSizeDoubleExtraLarge
          ),

          const SizedBox(width: Dimensions.paddingSizeLarge),

          organizationOverviewItem(
              context: context,
              height: 150,
              width: 140,
              leadingIcon: Icons.bar_chart_outlined,
              title: "Total Instructor",
              totalSellerAmount: 35.00,
              iconSize: Dimensions.iconSizeDefault,
              titleFontSize: Dimensions.fontSizeDefault,
              sellerAmountFontSize: Dimensions.fontSizeLarge,
              sellerAmountPadding: Dimensions.paddingSizeDoubleExtraLarge,
              sellerAmountColor: const Color(0xff24D6A5),
              sign: "+",
              sellerAmountHeight: Dimensions.paddingSizeDoubleExtraLarge
          ),

        ]),

        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(children: [

          organizationOverviewItem(
              context: context,
              height: 150,
              width: 140,
              leadingIcon: Icons.bar_chart_outlined,
              title: "Total Students",
              totalSellerAmount: 245367.00,
              iconSize: Dimensions.iconSizeDefault,
              titleFontSize: Dimensions.fontSizeDefault,
              sellerAmountFontSize: Dimensions.fontSizeLarge,
              sellerAmountPadding: Dimensions.paddingSizeDoubleExtraLarge,
              sellerAmountColor: const Color(0xffFFA600),
              sign: "+",
              sellerAmountHeight: Dimensions.paddingSizeDoubleExtraLarge
          ),

          const SizedBox(width: Dimensions.paddingSizeLarge),

          organizationOverviewItem(
              context: context,
              height: 150,
              width: 140,
              leadingIcon: Icons.bar_chart_outlined,
              title: "Total Enrollment",
              totalSellerAmount: 196784.00,
              iconSize: Dimensions.iconSizeDefault,
              titleFontSize: Dimensions.fontSizeDefault,
              sellerAmountFontSize: Dimensions.fontSizeLarge,
              sellerAmountPadding: Dimensions.paddingSizeDoubleExtraLarge,
              sellerAmountColor: const Color(0xffFF5630),
              sign: "+",
              sellerAmountHeight: Dimensions.paddingSizeDoubleExtraLarge
          ),

        ]),


      ])

    ]);
  }

  Widget organizationOverviewItem({
    required IconData leadingIcon,
    required String title,
    required double totalSellerAmount,
    required double height,
    required double width,
    required double iconSize,
    required double titleFontSize,
    required double sellerAmountFontSize,
    required double sellerAmountPadding,
    required Color sellerAmountColor,
    required String sign,
    required double sellerAmountHeight,
    required BuildContext context}){
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeLarge),
      height: height,
      width: (MediaQuery.of(context).size.width - width) / 4,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
        Row(children: [
          Icon(leadingIcon,size: iconSize),
          const SizedBox(width: Dimensions.paddingSizeLarge),
          Text(title,style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color,fontSize: titleFontSize)),
        ]),

        SizedBox(height: sellerAmountHeight),

        Row(children: [

          Container(
            margin: EdgeInsets.only(left: sellerAmountPadding),
            child: Text("$totalSellerAmount$sign",style: ubuntuBold.copyWith(color: sellerAmountColor,fontSize: sellerAmountFontSize)),
          ),

        ]),

      ]),
    );
  }

}
