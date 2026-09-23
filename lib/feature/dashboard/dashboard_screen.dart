import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/dashboard/widgets/best_sellers.dart';
import 'package:getdash/feature/dashboard/widgets/best_selling_products.dart';
import 'package:getdash/feature/dashboard/widgets/order_summery_section.dart';
import 'package:getdash/feature/dashboard/widgets/recent_orders.dart';
import 'package:getdash/feature/dashboard/widgets/sales_report.dart';
import 'package:getdash/feature/dashboard/widgets/summery_section.dart';
import 'package:getdash/feature/dashboard/widgets/total_products_customers.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/responsive.dart';
import 'widgets/unread_message_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,

      body: SafeArea(
        child: SizedBox(
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                  const UnreadMessageSection(),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  ResponsiveWidget(
                                    mobile: SummerySection(
                                      crossAxisCount: screenWidth < 850 ? 2 : 4,
                                      childAspectRatio:  screenWidth < 850 && screenWidth > 350 ? 1.5 : 1,
                                    ),
                                    tablet:  SummerySection(
                                      childAspectRatio: screenWidth < 1100 && screenWidth > 850 ? 1.2 : 1,
                                    ),
                                    desktop: SummerySection(
                                      childAspectRatio: screenWidth < 1350 ? 1.5 : 2.5,
                                    )
                                 ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //sales report
                                      const SalesReport(),
                                      //total product & customer
                                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                                      if(!ResponsiveHelper.isMobile(context))
                                        const Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Column(
                                            children: [
                                              TotalProductsCustomers(),
                                              SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                                              BestSellers(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  if(ResponsiveHelper.isMobile(context))
                                    const TotalProductsCustomers(),
                                  if(ResponsiveHelper.isMobile(context))
                                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                                  if(ResponsiveHelper.isMobile(context))
                                  
                                    const BestSellers(),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  ResponsiveWidget(
                                      mobile: const OrderSummerySection(
                                        crossAxisCount: 1,
                                        childAspectRatio: 3,
                                      ),
                                      tablet:  OrderSummerySection(
                                        childAspectRatio: screenWidth < 1100 && screenWidth > 850 ? 1.8 : 1,
                                      ),
                                      desktop: const OrderSummerySection(
                                        childAspectRatio:2,
                                      )
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //sales report
                                      const Expanded(child: RecentOrders()),
                                      if(ResponsiveHelper.isDesktop(context) )
                                        const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                                      if(ResponsiveHelper.isDesktop(context))
                                      const Expanded(child: BestSellingProducts()),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  if(!ResponsiveHelper.isDesktop(context))
                                    const BestSellingProducts(),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
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
      ),
    );
  }
}

