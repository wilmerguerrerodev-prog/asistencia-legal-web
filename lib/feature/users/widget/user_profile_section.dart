import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: Column(children: [

        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(Images.edit,scale: 3,),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text("edit".tr,style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5))),
            ]),

        const SizedBox(height: Dimensions.paddingSizeSmall),
        CircleAvatar(maxRadius: Dimensions.radiusExtraMoreLarge, child: Image.asset(Images.person)),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Text(
            "Cameron Williamson",
            style: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color:Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)
            )),
        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("overview".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(
            children: [
              bookingInfo(title: "1",subTitle: "Total Booking Placed",context: context),
              const SizedBox(width: Dimensions.paddingSizeLarge),
              bookingInfo(title: "400.50\$",subTitle: "Total Booking Amount", context: context)]),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        Container(
            decoration: BoxDecoration(
                color:  Theme.of(context).primaryColor.withOpacity(.05),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(children: [
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
              Text("booking_overview".tr,style: ubuntuLight.copyWith(fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Container(height: 150,width: 150,decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color: Colors.red,width: 10))),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  bookingStatus(color: Colors.green, title: "pending".tr),
                  bookingStatus(color: Colors.pink, title: "accepted".tr),
                  bookingStatus(color: Colors.lightGreen, title: "ongoing".tr),
                ],
              )
            ])),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("personal_details".tr,style: ubuntuMedium.copyWith(),),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            personalDetailsInfo(title: "phone_number".tr,subTitle: ": (480) 555-0103", context: context ),
            personalDetailsInfo(title: "email_address".tr,subTitle: ": tim.jennings@example.com" , context: context ),
            personalDetailsInfo(title: "address".tr,subTitle: ": 2972 Westheimer Rd. Santa Ana Illinois 85486 ",  context: context ),
            personalDetailsInfo(title: "about".tr,subTitle: ": Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.", context: context ),
            personalDetailsInfo(title: "email_address".tr,subTitle: ": getdesh@gmail.com", context: context ),
          ],
        )


      ]),
    );
  }

  Widget bookingInfo({required String title,required String subTitle, required BuildContext context}){
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall),
          height: Dimensions.containerHeight,
          decoration: BoxDecoration(
              color:  Theme.of(context).primaryColor.withOpacity(.05),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Text(title,style: ubuntuBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).primaryColor,
            )),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text(subTitle,style: ubuntuLight.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
          ])),
    );
  }

  bookingStatus({required Color color,required String title}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration:  BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge))
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall,),
          Text(title),
        ],
      ),
    );
  }

  Widget personalDetailsInfo({required String title, required String subTitle, required BuildContext context}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          SizedBox(
              width: 130,
              child: Text(
                title,
                style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),
              )),
          Expanded(
              child: Text(
                subTitle,
                style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),
              ))
        ],
      ),
    );
  }

}