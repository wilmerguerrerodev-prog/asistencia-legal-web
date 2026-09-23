import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/dashboar3_summary_card.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/dashboard3_ultimate_card1.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/dashboard3_ultimate_card2.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/dashboard_3_messege_section.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/dashboard_demo3_ultimate.dart';
import 'package:getdash/feature/dashboarddemo3/widgets/sales_revenue.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/responsive.dart';

class DashboardDemoScreen3 extends StatefulWidget {
  const DashboardDemoScreen3({super.key});

  @override
  State<DashboardDemoScreen3> createState() => _DashboardDemoScreen3State();
}

class _DashboardDemoScreen3State extends State<DashboardDemoScreen3> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer() : null,
      body: SafeArea(
          child: SizedBox(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context)) const MenuDrawer(),
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const WebMenuBar(),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraLarge),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraMoreLarge),
                            const DashboardDemo3MessegeSection(),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            ResponsiveWidget(
                                mobile: DemoThreeSummeryCard(
                                  crossAxisCount: screenWidth < 850 ? 1 : 2,
                                  childAspectRatio:
                                      screenWidth < 850 && screenWidth > 350
                                          ? 4.8
                                          : 2.3,
                                ),
                                tablet: DemoThreeSummeryCard(
                                  childAspectRatio:
                                      screenWidth < 1100 && screenWidth > 850
                                          ? 3.3
                                          : 4.2,
                                ),
                                desktop: DemoThreeSummeryCard(
                                  childAspectRatio:
                                      screenWidth < 1350 ? 4.3 : 5.4,
                                )),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            // const SalesRevenue(),

                            //Sales Revenue..........

                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),

                            if (MediaQuery.of(context).size.width < 850)
                              DashboardDemo3Ultimate(
                                crossAxisCount: screenWidth < 850 ? 1 : 1,
                                childAspectRatio:
                                    screenWidth < 850 && screenWidth > 350
                                        ? 0.8
                                        : 1,
                              ),
                            if (MediaQuery.of(context).size.width >= 850)
                              const SalesRevenue(),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),

                            Row(
                              children: [
                                const Expanded(
                                  child: UltimateCard1(),
                                ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const SizedBox(
                                    width: Dimensions.paddingSizeExtraLarge,
                                  ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const Expanded(child: UltimateCard2())
                              ],
                            ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge,
                              ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const UltimateCard2(),
                          
                             const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                          ],
                        ),
                      ),
                    ))
                  ],
                ))
          ],
        ),
      )),
    );
  }
}
