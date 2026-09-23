import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;

  @override
  Widget build(BuildContext context) {
  double screenWidth = Get.width - 75;
    return Container(
      height: 300,
      
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge,
            vertical: Dimensions.paddingSizeLarge),
        child: SizedBox(
           width: screenWidth / 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Activites",
                    style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _value1,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side:const BorderSide(color: Colors.green),
                    onChanged: (value) {
                      setState(() {
                        _value1 = value!;
                      });
                    },
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Text(Data[0]),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _value2,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side:const BorderSide(color: Colors.green),
                    onChanged: (value) {
                      setState(() {
                        _value2 = value!;
                      });
                    },
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Text(Data[1]),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _value3,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side:const BorderSide(color: Colors.green),
                    onChanged: (value) {
                      setState(() {
                        _value3 = value!;
                      });
                    },
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Text(Data[2]),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _value4,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side:const BorderSide(color: Colors.green),
                    onChanged: (value) {
                      setState(() {
                        _value4 = value!;
                      });
                    },
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Text(Data[3]),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _value5,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    side:const BorderSide(color: Colors.green),
                    onChanged: (value) {
                      setState(() {
                        _value5 = value!;
                      });
                    },
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Text(Data[4]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List Data = [
    "Identify the purpose of the product card.",
    "Collect essential product details,pricing.",
    "Create high quality image in different angles.",
    "Write an article about upcoming product.",
    "Clearly display the price of the product."
  ];


}
