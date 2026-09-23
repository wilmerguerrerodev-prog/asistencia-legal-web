import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'choose_language_dialog.dart';


class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
   const WebMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MenuButtonWebIcon(icon: Images.menu, onTap: () {
              Get.find<MenuDrawerController>().toggleMenuDrawer();
              Scaffold.of(context).openDrawer();
              },),

        Row(
          children: [
            MenuButtonWebIcon(icon: Images.chat, onTap: () {  },),
            MenuButtonWebIcon(icon: Images.notification, onTap: () {  },),
            GetBuilder<ThemeController>(builder: (themeController){
              return MenuButtonWebIcon(icon: themeController.darkTheme ? Images.lightMode:Images.darkMode, onTap: (){
                themeController.toggleTheme();
              });
            }),

            MenuButtonWebIcon(icon: Images.globe, onTap: () {
              if (Get.isSnackbarOpen) {
                Get.back();
              }
              Get.dialog(ChooseLanguageDialog(
                description: 'choose_a_language'.tr,
                onYesPressed: () {
                },
              ));
            },)
          ],
        )

      ]),
    );
  }
  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 80);
}

class MenuButtonWebIcon extends StatelessWidget {
  final String? icon;
  final Function() onTap;
  const MenuButtonWebIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), shape: BoxShape.circle),
            child: Image.asset(icon!,scale: 3,color: Colors.grey.shade400,)),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      ]),
    );
  }
}

class MenuButtonWeb extends StatelessWidget {
  final String? title;
  final bool isCart;
  final Function() onTap;

  const MenuButtonWeb({super.key, required this.title, this.isCart = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), shape: BoxShape.circle),
        child: IconButton(onPressed: (){}, icon: const Icon(Icons.language,size: 18),color: Colors.black),
      ),);
  }
}

