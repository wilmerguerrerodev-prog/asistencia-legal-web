import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/common_add_section.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/blog_post/widget/all_blog_list.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/users/widget/search_user_section.dart';
import 'package:getdash/utils/dimensions.dart';


class ApplicationBlogScreen extends StatefulWidget {
  const ApplicationBlogScreen({Key? key}) : super(key: key);

  @override
  State<ApplicationBlogScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<ApplicationBlogScreen> {
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
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
                                    children:  [
                                      const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                      CommonAddSection(title: 'application_blogs'.tr, addBtnTitle: 'add_new_blog'.tr,),
                                      const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                      SearchSection(screenWidth: screenWidth,),
                                      const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                                      const AllBlogList(),
                                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeLarge,),
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

