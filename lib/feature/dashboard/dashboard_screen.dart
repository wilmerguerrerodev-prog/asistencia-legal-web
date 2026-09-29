import 'package:flutter/material.dart';
import 'package:getdash/components/main_page_layout.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/conductor/sos_conductor_view.dart';
import 'package:getdash/utils/dimensions.dart';
import 'widgets/unread_message_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return MainPageLayout(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : Dimensions.paddingSizeExtraLarge,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(
                height: isMobile ? 12 : Dimensions.paddingSizeExtraMoreLarge,
              ),
              const UnreadMessageSection(),
              SizedBox(height: isMobile ? 12 : Dimensions.paddingSizeExtraLarge),
              const SosConductorView(isEmbeddedInDashboard: true),
              SizedBox(height: isMobile ? 20 : Dimensions.paddingSizeExtraLarge),
            ],
          ),
        ),
      ),
    );
  }
}
