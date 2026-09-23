import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/activities.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/browser_stats.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/dashboard2_summary_card.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/dashboard_2_messege_section.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/member_performance.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/sales_overview.dart';
import 'package:getdash/feature/dashboarddemo2/widgets/social_media.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/responsive.dart';

class DashboardDemoScreen2 extends StatefulWidget {
  const DashboardDemoScreen2({super.key});

  @override
  State<DashboardDemoScreen2> createState() => _DashboardDemoScreen2State();
}

class _DashboardDemoScreen2State extends State<DashboardDemoScreen2> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width - 75;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer() : null,
      body: SafeArea(child: SizedBox(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context)) const MenuDrawer(),
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const WebMenuBar(),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                            const MessegeSection(),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            ResponsiveWidget(
                                mobile: DemoOneSummeryCard(
                                  crossAxisCount: screenWidth < 850 ? 2 : 4,
                                  childAspectRatio: screenWidth < 850 && screenWidth > 350
                                          ? 1.9
                                          : 1,
                                ),
                                tablet: DemoOneSummeryCard(
                                  childAspectRatio: screenWidth < 1100 && screenWidth > 850
                                          ? 1.2
                                          : 1,
                                ),
                                desktop: DemoOneSummeryCard(childAspectRatio: screenWidth < 1350 ? 1.5 : 2.5,)),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            Row(
                              children: [
                                const Expanded(child: SalesOverview()),
                                if (ResponsiveHelper.isDesktop(context))
                                  const SizedBox(
                                    width: Dimensions.paddingSizeExtraLarge,
                                  ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const Expanded(child: BrowserStats())
                              ],
                            ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge,
                              ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const BrowserStats(),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            Row(
                              children: [
                                const Expanded(child: Activities()),
                                if (ResponsiveHelper.isDesktop(context))
                                  const SizedBox(
                                    width: Dimensions.paddingSizeExtraLarge,
                                  ),
                                if (ResponsiveHelper.isDesktop(context))
                                  const Expanded(child: SocialMediaTraffic())
                              ],
                            ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge,
                              ),
                            if (!ResponsiveHelper.isDesktop(context))
                              const SocialMediaTraffic(),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            const MemberPerformance(),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
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
