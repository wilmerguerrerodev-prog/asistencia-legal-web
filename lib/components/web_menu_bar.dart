import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';


class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
   const WebMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: 8,
          ),
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    size: 20,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "LegalTech",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),

          Row(
            children: [
              GetBuilder<ThemeController>(builder: (themeController) {
                final isDark = themeController.darkTheme;
                return InkWell(
                  onTap: () => themeController.toggleTheme(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      size: 19,
                      color: isDark ? const Color(0xFFF59E0B) : const Color(0xFF64748B),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getUserProfileScreen());
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 20,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    ),
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
            child: Image.asset(
              icon!,
              scale: 3,
              color: Colors.grey.shade400,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.circle_outlined, size: 18, color: Colors.grey.shade400),
            )),
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

