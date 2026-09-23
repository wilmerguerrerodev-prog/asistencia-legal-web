import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/messege_section.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/new_product.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/demo_one_summery_card.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/user_overview.dart';
import 'package:getdash/feature/dashboarddemo1/widgets/user_section.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/responsive.dart';

class DashboardScreen1 extends StatefulWidget {
  const DashboardScreen1({super.key});

  @override
  State<DashboardScreen1> createState() => _DashboardScreen1State();
}

class _DashboardScreen1State extends State<DashboardScreen1> {
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
                                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                    const MessegeSection(),
                                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    ResponsiveWidget(
                                        mobile: DemoOneSummeryCard(
                                          crossAxisCount: screenWidth < 850 ? 2 : 4,
                                          childAspectRatio:  screenWidth < 850 && screenWidth > 350 ? 1.9 : 1,),
                                        tablet:  DemoOneSummeryCard(
                                          childAspectRatio: screenWidth < 1100 && screenWidth > 850 ? 1.2 : 1,
                                        ),
                                        desktop: DemoOneSummeryCard(
                                          childAspectRatio: screenWidth < 1350 ? 1.5 : 2.5,
                                    )
                                ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                      Row(
                                        children: [
                                            const Expanded(child: UserOverviewChart()),
                                          if(ResponsiveHelper.isDesktop(context))
                                          const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                                          if(ResponsiveHelper.isDesktop(context))
                                          const Expanded(child: NewProduct())
                                    ],
                                  ),
                                  if(!ResponsiveHelper.isDesktop(context))
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                                  if(!ResponsiveHelper.isDesktop(context))
                                   const NewProduct(),
                                  //users......
                                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                  const Users(),
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
