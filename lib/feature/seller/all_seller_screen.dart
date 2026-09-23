import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/seller/widget/all_seller_list.dart';
import 'package:getdash/feature/seller/widget/seller_info_section.dart';
import 'package:getdash/feature/users/widget/common_header.dart';
import 'package:getdash/feature/users/widget/search_user_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/responsive.dart';


class AllSellerScreen extends StatefulWidget {
  const AllSellerScreen({super.key});

  @override
  State<AllSellerScreen> createState() => _AllSellerScreenState();
}

class _AllSellerScreenState extends State<AllSellerScreen> {
  List<String> itemList = ["Filter By Status","Filter By Date","Filter By Order","Filter By None"];
  String? selectedItem = "Filter By Status";

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;

    return Scaffold(
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body:  SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeLarge,
                            horizontal: Dimensions.paddingSizeLarge),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ?Dimensions.paddingSizeSmall:Dimensions.paddingSizeExtraLarge),
                                child: Column(
                                  children:  [
                                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                    CommonHeader(title: 'all_sellers'.tr,),
                                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                    ResponsiveWidget(
                                        mobile: SellerInfoSection(
                                          crossAxisCount: screenWidth < 850 ? 1 : 4,
                                          childAspectRatio:  screenWidth < 850? 3 : 1,
                                        ),
                                        tablet:  SellerInfoSection(
                                          childAspectRatio: screenWidth < 1100 && screenWidth > 850 ? 1.2 : 1,
                                        ),
                                        desktop: SellerInfoSection(
                                          childAspectRatio: screenWidth < 1100 ? 1.7:2,
                                        )
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                    SearchSection(screenWidth: screenWidth,),
                                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                    const AllSellerList(),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

