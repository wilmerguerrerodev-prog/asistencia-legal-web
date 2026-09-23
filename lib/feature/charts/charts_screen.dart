import 'package:flutter/material.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/charts/widgets/bar_chart.dart';
import 'package:getdash/feature/charts/widgets/line_chart.dart';
import 'package:getdash/feature/charts/widgets/piechart.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'widgets/scatter_chart.dart';


class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
      body: SafeArea(
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
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraMoreLarge,
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: GetDashLineChart()),
                                          if(!ResponsiveHelper.isMobile(context))
                                          const Expanded(child: GetDashBarChart()),
                                        ],
                                      ),
                                      if(ResponsiveHelper.isMobile(context))
                                        const GetDashBarChart(),
                                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                      Row(
                                        children: [
                                          const Expanded(child: GetDashPieChart()),
                                          if(!ResponsiveHelper.isMobile(context))
                                          const Expanded(child: GetDashScatterChart()),
                                        ],
                                      ),
                                      if(ResponsiveHelper.isMobile(context))
                                        const GetDashScatterChart(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                              const FooterSection(),
                            ],
                          ),
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

