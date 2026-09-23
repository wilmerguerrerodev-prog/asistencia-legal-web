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
                      onExpansionChanged: (z) {
                        if(menuModel.route != null){
                          Get.find<MenuDrawerController>().updateSelectedIndex(selectedIndex = z ? index : -1);
                          Get.find<MenuDrawerController>().updateSubMenuSelectedIndex('');
                          Get.offAndToNamed(menuModel.route!);
                        }
                      },
                      initiallyExpanded: selected ? true : false,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,

                      title: Row(
                        children: [
                          if(menuModel.icon != null)
                          Image.asset(menuModel.icon!, color: selected ?Theme.of(context).secondaryHeaderColor: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),scale: 4,),
                          if(menuModel.icon != null)
                          const SizedBox(width: Dimensions.paddingSizeDefault,),
                          Text(menuModel.menuTitle!.tr,style: ubuntuMedium.copyWith(
                            color: selected ?Theme.of(context).secondaryHeaderColor: Theme.of(context).textTheme.bodyMedium!.color!,
                            fontSize: Dimensions.fontSizeSmall,
                          ),),
                        ],
                      ),

                      trailing: menuModel.subMenus == null ? const SizedBox() : Icon(
                        selected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: selected ?Theme.of(context).secondaryHeaderColor: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5),
                      ),

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
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListTile(
        leading: isExpanded ? const FlutterLogo() : null,
        title:isExpanded ? Text( "GetDash",
          style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
        ) :   const FlutterLogo(),
        onTap: Get.find<MenuDrawerController>().toggleMenuDrawer,
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
                      child:menuList[index].icon !=  null ?  Image.asset(menuList[index].icon!, color:selected ? Theme.of(context).primaryColor: Colors.white,scale: 3,): Container(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget subMenuTitle({required SubMenu subMenu, required int parentIndex, required int subMenuIndex}) {
    return InkWell(
      onTap: () {
        Get.find<MenuDrawerController>().updateSelectedIndex(parentIndex);
        Get.find<MenuDrawerController>().updateSubMenuSelectedIndex(subMenu.subMenuTitle!);
        if(subMenu.route != null) {
          Get.toNamed(subMenu.route!);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
           subMenu.subMenuTitle!.tr,
          style: ubuntuRegular.copyWith(
              color: Get.find<MenuDrawerController>().subMenuSelectedTitle == subMenu.subMenuTitle ? Theme.of(context).secondaryHeaderColor:Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: .5)),
        ),
      ),
    );
  }
}
