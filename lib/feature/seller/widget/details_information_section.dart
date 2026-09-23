import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class DetailsInformationSection extends StatelessWidget {
  const DetailsInformationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

      Expanded(
          child: detailsInformationItem(
              image: Images.belle,
              subTitle: "",
              title: "The Walt Disney Company",
              mobileNumber: "(480) 555-0103",
              email: "tim.jennings@example.com",
              location: "6391 Elgin St. Celina, Delaware 10299",
              context: context)),

      const SizedBox(width: Dimensions.paddingSizeLarge),

      Expanded(
          child: detailsInformationItem(
              image: Images.belle,
              subTitle: "Co-Founder",
              title: "The Walt Disney Company",
              mobileNumber: "(480) 555-0103",
              email: "tim.jennings@example.com",
              location: "",
              context: context)),

    ]);
  }

  Widget detailsInformationItem({
    required String image,
    required String title,
    String? subTitle,
    required String mobileNumber,
    required String email,
    String? location,
    required BuildContext context}){
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraLarge),
      height: 200,
      width: (MediaQuery.of(context).size.width - 75) / 4,
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06)),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

        SizedBox(height: 150,width: 150,child: Image.asset(image)),

        const SizedBox(width: Dimensions.paddingSizeLarge),

        SizedBox(
          height: 150,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [

            Text(title,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),


            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(subTitle!),
            const SizedBox(height: Dimensions.paddingSizeLargeThirty),

            Row(children: [

              const Icon(Icons.call_outlined,size: Dimensions.iconSizeSmall),

              const SizedBox(width: Dimensions.paddingSizeDefault),

              Text(mobileNumber),


            ]),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(children: [

              const Icon(Icons.email_outlined,size: Dimensions.iconSizeSmall),

              const SizedBox(width: Dimensions.paddingSizeDefault),

              Text(email),


            ]),

            const SizedBox(height: Dimensions.paddingSizeSmall),


            Row(children: [

              location != ""? const Icon(Icons.location_on_outlined,size: Dimensions.iconSizeSmall): const SizedBox(),

              const SizedBox(width: Dimensions.paddingSizeDefault),

              Text(location!),


            ]),


          ]),
        ),


      ]),
    );
  }

}
