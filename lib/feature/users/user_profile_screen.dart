import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/feature/users/widget/user_order_list.dart';
import 'package:getdash/feature/users/widget/user_profile_section.dart';
import 'package:getdash/utils/dimensions.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
          child: Row(
            children: [
              if (ResponsiveHelper.isDesktop(context))
                const MenuDrawer(),
              Expanded(
                child: Column(
                  children: [
                    const WebMenuBar(),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeLarge),
                            child: Column(
                              children: [
                                Container(decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                                ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                                    child: Column(
                                        children:  [
                                          const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                          CommonHeader(title: "user_profile".tr),
                                          const SizedBox(height: Dimensions.paddingSizeDoubleExtraLarge),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: screenWidth / 3.5,
                                                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.06),),
                                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                                                    child: const UserProfileSection()),
                                                const SizedBox(width: Dimensions.paddingSizeLarge),
                                                const Expanded(
                                                  child: UserOrderList(),
                                                  ),
                                              ]),
                                        ]),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge,),
                                const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                                const FooterSection(),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}