import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';
import 'controller/menu_drawer_controller.dart';
import 'model/menu_model.dart';


class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuDrawerController>(
      builder: (menuDrawerController){
        if(ResponsiveHelper.isMobile(context)){
          return expandedMenuList(
              menuDrawerController.isMenuDrawerExpanded,
              menuDrawerController.selectedIndex);
        }else{
          return menuDrawerController.isMenuDrawerExpanded ? expandedMenuList(
              menuDrawerController.isMenuDrawerExpanded,
              menuDrawerController.selectedIndex) :
          collapsesMenuList(menuDrawerController.isMenuDrawerExpanded,menuDrawerController.selectedIndex);
        }
      },
    );
  }


  Widget expandedMenuList(isExpanded,selectedIndex) {
    return Container(
      width: 260,
      color: Theme.of(context).primaryColorLight,
    // color: Colors.amber,
      child: Column(
        children: [
          controlTile(isExpanded),
          Expanded(
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (BuildContext context, int index) {
                MenuModel menuModel = menuList[index];
                bool selected = selectedIndex == index;
                return Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      key: Key('${index}_$selected'),
                      onExpansionChanged: (z) {
                        if(menuModel.route != null){
                          Get.find<MenuDrawerController>().updateSelectedIndex(selectedIndex = z ? index : -1);
                          Get.find<MenuDrawerController>().updateSubMenuSelectedIndex('');
                          Get.offAndToNamed(menuModel.route!);
                        }
                      },
                      initiallyExpanded: selected,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      iconColor: Theme.of(context).secondaryHeaderColor,
                      collapsedIconColor: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),

                      title: Row(
                        children: [
                          if (menuModel.iconData != null)
                            Icon(
                              menuModel.iconData,
                              size: 20,
                              color: selected
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withValues(alpha: .5),
                            )
                          else if (menuModel.icon != null)
                            Image.asset(
                              menuModel.icon!,
                              color: selected
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                      .withValues(alpha: .5),
                              scale: 4,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.circle_outlined,
                                size: 20,
                                color: selected
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withValues(alpha: .5),
                              ),
                            ),
                          if (menuModel.iconData != null || menuModel.icon != null)
                            const SizedBox(
                              width: Dimensions.paddingSizeDefault,
                            ),
                          Expanded(
                            child: Text(
                              menuModel.menuTitle!.tr,
                              style: ubuntuMedium.copyWith(
                                color: selected
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).textTheme.bodyMedium!.color!,
                                fontSize: Dimensions.fontSizeSmall,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      trailing: menuModel.subMenus == null ? const SizedBox() : null,

                      children: menuModel.subMenus == null
                          ?  []: menuModel.subMenus!.asMap().map((i, subMenu) => MapEntry(i,subMenuTitle(subMenu:subMenu, parentIndex:index, subMenuIndex:i))).values.toList()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget controlMenuButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: MenuButtonWebIcon(icon: Images.menu, onTap: Get.find<MenuDrawerController>().toggleMenuDrawer),
    );
  }

  Widget controlTile(bool isExpanded) {
    return Padding(
<<<<<<< HEAD
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListTile(
        leading: isExpanded
            ? Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.gavel_rounded, color: Theme.of(context).primaryColor, size: 22),
              )
            : null,
        title: isExpanded
            ? Text(
                "LegalTech",
                style: ubuntuBold.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: Dimensions.fontSizeLarge,
                  letterSpacing: 0.5,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.gavel_rounded, color: Theme.of(context).primaryColor, size: 22),
              ),
=======
      padding: const EdgeInsets.only(top: 20, bottom: 25, left: 12, right: 12),
      child: InkWell(
>>>>>>> 018199037cc905aab4537c4ad37e9fbbabe8139c
        onTap: Get.find<MenuDrawerController>().toggleMenuDrawer,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Icon(
                  Icons.balance_rounded,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: 20,
                ),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "LegalTech",
                        style: ubuntuBold.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: Dimensions.fontSizeLarge,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "PRO",
                          style: ubuntuBold.copyWith(
                            fontSize: 9,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget collapsesMenuList(isExpanded,selectedIndex) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 100,
      color: Colors.black,
      child: Column(
        children: [
          controlTile(isExpanded),
          Expanded(
            child: ListView.builder(
                itemCount: menuList.length,
                itemBuilder: (contex, index) {
                  bool selected = selectedIndex == index;

                  return InkWell(
                    onTap: () {
                      Get.find<MenuDrawerController>().updateSelectedIndex(index);
                      Get.find<MenuDrawerController>().toggleMenuDrawer();
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: menuList[index].iconData != null
                          ? Icon(
                              menuList[index].iconData,
                              size: 22,
                              color: selected ? Theme.of(context).primaryColor : Colors.white,
                            )
                          : (menuList[index].icon != null
                              ? Image.asset(
                                  menuList[index].icon!,
                                  color: selected ? Theme.of(context).primaryColor : Colors.white,
                                  scale: 3,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.circle_outlined,
                                    size: 20,
                                    color: selected ? Theme.of(context).primaryColor : Colors.white,
                                  ),
                                )
                              : Container()),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget subMenuTitle({required SubMenu subMenu, required int parentIndex, required int subMenuIndex}) {
    bool isSelected = Get.find<MenuDrawerController>().subMenuSelectedTitle == subMenu.subMenuTitle;
    return InkWell(
      onTap: () {
        Get.find<MenuDrawerController>().updateSelectedIndex(parentIndex);
        Get.find<MenuDrawerController>().updateSubMenuSelectedIndex(subMenu.subMenuTitle!);
        if (subMenu.route != null && Get.currentRoute != subMenu.route) {
          Get.toNamed(subMenu.route!);
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 36, right: 14, top: 2, bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                subMenu.subMenuTitle!.tr,
                style: ubuntuRegular.copyWith(
                  color: isSelected
                      ? Theme.of(context).secondaryHeaderColor
                      : Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.7),
                  fontSize: Dimensions.fontSizeSmall,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
