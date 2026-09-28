import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
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

  List<MenuModel> _getMenuList() {
    if (Get.isRegistered<AuthMockController>()) {
      return getMenuListForRole(Get.find<AuthMockController>().role);
    }
    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthMockController>(
      builder: (auth) {
        return GetBuilder<MenuDrawerController>(
          builder: (menuDrawerController) {
            if (ResponsiveHelper.isMobile(context)) {
              return expandedMenuList(
                  true, menuDrawerController.selectedIndex, auth);
            } else {
              return menuDrawerController.isMenuDrawerExpanded
                  ? expandedMenuList(
                      menuDrawerController.isMenuDrawerExpanded,
                      menuDrawerController.selectedIndex,
                      auth)
                  : collapsesMenuList(
                      menuDrawerController.isMenuDrawerExpanded,
                      menuDrawerController.selectedIndex,
                      auth);
            }
          },
        );
      },
    );
  }

  Widget expandedMenuList(isExpanded, selectedIndex, AuthMockController auth) {
    final activeList = _getMenuList();

    return Container(
      width: 260,
      color: Theme.of(context).primaryColorLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controlTile(true),
          _buildRoleSwitcherTile(context, auth),
          Expanded(
            child: ListView.builder(
              itemCount: activeList.length,
              itemBuilder: (BuildContext context, int index) {
                MenuModel menuModel = activeList[index];
                bool selected = selectedIndex == index;
                return Theme(
                  data: ThemeData().copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                      key: Key('${index}_$selected'),
                      onExpansionChanged: (z) {
                        if (menuModel.route != null) {
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
      child: MenuButtonWebIcon(
        icon: Images.menu,
        onTap: Get.find<MenuDrawerController>().toggleMenuDrawer,
      ),
    );
  }

  Widget controlTile(bool isExpanded) {
    final bool showTitle = isExpanded || ResponsiveHelper.isMobile(context);
    return Align(
      alignment: showTitle ? Alignment.centerLeft : Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 25,
          left: showTitle ? 16 : 8,
          right: showTitle ? 16 : 8,
        ),
        child: InkWell(
          onTap: () {
            if (!ResponsiveHelper.isMobile(context)) {
              Get.find<MenuDrawerController>().toggleMenuDrawer();
            }
          },
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.gavel_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 22,
                  ),
                ),
                if (showTitle) ...[
                  const SizedBox(width: 12),
                  Text(
                    "LegalTech",
                    style: ubuntuBold.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: Dimensions.fontSizeLarge,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget collapsesMenuList(isExpanded, selectedIndex, AuthMockController auth) {
    final activeList = _getMenuList();

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 100,
      color: Colors.black,
      child: Column(
        children: [
          controlTile(isExpanded),
          Expanded(
            child: ListView.builder(
                itemCount: activeList.length,
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
                      child: activeList[index].iconData != null
                          ? Icon(
                              activeList[index].iconData,
                              size: 22,
                              color: selected ? Theme.of(context).primaryColor : Colors.white,
                            )
                          : (activeList[index].icon != null
                              ? Image.asset(
                                  activeList[index].icon!,
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

  Widget _buildRoleSwitcherTile(BuildContext context, AuthMockController auth) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF1D4ED8).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Text(
            auth.user.role.iconEmoji,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  auth.user.role.shortBadge,
                  style: ubuntuBold.copyWith(
                    fontSize: 11,
                    color: const Color(0xFF1D4ED8),
                  ),
                ),
                Text(
                  auth.user.name,
                  style: ubuntuRegular.copyWith(
                    fontSize: 10.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (auth.isItAdmin)
            InkWell(
              onTap: () => _showRoleSwitcherDialog(context, auth),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D4ED8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rol",
                      style: ubuntuBold.copyWith(
                        fontSize: 10,
                        color: const Color(0xFF1D4ED8),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        size: 14, color: Color(0xFF1D4ED8)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showRoleSwitcherDialog(BuildContext context, AuthMockController auth) {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(ctx).padding.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.switch_account_rounded,
                        color: Color(0xFF1D4ED8)),
                    const SizedBox(width: 8),
                    Text(
                      "Cambiar Rol (Modo Testing RBAC)",
                      style: ubuntuBold.copyWith(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Selecciona un perfil para simular su entorno y permisos:",
                  style: ubuntuRegular.copyWith(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 14),
                ...UserRole.values.map((role) {
                  final isSelected = auth.role == role;
                  String userDesc = '';
                  switch (role) {
                    case UserRole.itAdmin:
                      userDesc = "Ing. Admin Sistemas • Telemetría y Configuración";
                      break;
                    case UserRole.adminLawyer:
                      userDesc = "Dr. Emir Vásquez • Director Legal & Despacho";
                      break;
                    case UserRole.associateLawyer:
                      userDesc = "Dra. Andrea Morales • Abogada Turno Ibarra";
                      break;
                    case UserRole.clientDriver:
                      userDesc = "Carlos Mendoza • Conductor SOS Unidad #42";
                      break;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1D4ED8)
                              .withValues(alpha: isDark ? 0.2 : 0.08)
                          : Theme.of(context)
                              .primaryColorLight
                              .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1D4ED8)
                            : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Text(
                        role.iconEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        role.displayName,
                        style: ubuntuBold.copyWith(
                          fontSize: 13,
                          color: isSelected ? const Color(0xFF1D4ED8) : null,
                        ),
                      ),
                      subtitle: Text(
                        userDesc,
                        style: ubuntuRegular.copyWith(fontSize: 11),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: Color(0xFF1D4ED8), size: 20)
                          : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        auth.switchRole(role);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
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
