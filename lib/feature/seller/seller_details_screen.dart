import 'package:flutter/material.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/decorated_tab_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/seller/widget/seller_details_settings.dart';
import 'package:getdash/feature/seller/widget/seller_overview.dart';
import 'package:getdash/feature/seller/widget/seller_payment.dart';
import 'package:getdash/feature/seller/widget/seller_product_list.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:getdash/utils/styles.dart';

class SellerDetailsScreen extends StatefulWidget {
  const SellerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SellerDetailsScreen> createState() => _SellerDetailsScreenState();
}

class _SellerDetailsScreenState extends State<SellerDetailsScreen> with TickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ResponsiveHelper.isDesktop(context) ?  const WebMenuBar() : null,

      body: Container(
        margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,right: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seller Details",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
              ),
              child: DecoratedTabBar(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withOpacity(.3),
                      width: 1.0,
                    ),
                  ),
                ),
                tabBar: TabBar(
                  padding: const EdgeInsets.only(top: 3),
                  unselectedLabelColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.4),
                  controller: _tabController,
                  labelColor:Get.isDarkMode? Colors.white : Theme.of(context).primaryColor,
                  labelStyle: ubuntuBold,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorPadding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  labelPadding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                  indicatorWeight: 2,
                  // onTap: (int? index) {
                  //
                  // },
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Products'),
                    Tab(text: 'Payment'),
                    Tab(text: 'Settings'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [

                  Row(
                    children: [
                      Expanded(child: SellerOverview()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: SellerProductList()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: SellerPayment()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: SellerDetailsSettings()),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
