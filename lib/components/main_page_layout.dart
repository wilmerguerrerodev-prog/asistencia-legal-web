import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/feature/menu/menu_screen.dart';

class MainPageLayout extends StatelessWidget {
  final Widget child;
  final bool showHeader;

  const MainPageLayout({
    super.key,
    required this.child,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);

    if (!Get.isRegistered<MenuDrawerController>()) {
      Get.put(MenuDrawerController());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barra superior fija (WebMenuBar)
            if (showHeader) ...[
              const WebMenuBar(),
              Container(
                height: 1,
                width: double.infinity,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
              ),
            ],

            // 2. Área principal inferior (debajo de la línea divisoria)
            Expanded(
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MenuDrawer(),
                        Expanded(child: child),
                      ],
                    )
                  : GetBuilder<MenuDrawerController>(
                      builder: (menuCtrl) {
                        final isOpen = menuCtrl.isMobileDrawerOpen;
                        return PopScope(
                          canPop: !isOpen,
                          onPopInvokedWithResult: (didPop, _) {
                            if (!didPop && isOpen) {
                              menuCtrl.closeMobileDrawer();
                            }
                          },
                          child: Stack(
                            children: [
                              // Pantalla activa debajo de la barra superior
                              Positioned.fill(child: child),

                              // Sombra de fondo oscura interactiva (tap para cerrar)
                              if (isOpen)
                                Positioned.fill(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => menuCtrl.closeMobileDrawer(),
                                    child: Container(
                                      color: Colors.black.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),

                              // Menú lateral que emerge EXACTAMENTE bajo la línea divisoria
                              if (isOpen)
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 240),
                                  curve: Curves.easeOutCubic,
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  width: 280,
                                  child: Material(
                                    elevation: 8,
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                    ),
                                    child: const MenuDrawer(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
