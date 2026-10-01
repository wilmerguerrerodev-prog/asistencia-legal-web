import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/core/services/firebase_service.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/feature/menu/controller/menu_drawer_controller.dart';
import 'package:getdash/utils/dimensions.dart';


class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  const WebMenuBar({super.key});

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "¿Cerrar Sesión?",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "¿Estás seguro de que deseas salir de tu cuenta en LegalTech? Tendrás que ingresar tus credenciales nuevamente.",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (Get.isRegistered<MenuDrawerController>()) {
                            Get.find<MenuDrawerController>().closeMobileDrawer();
                          }
                          FirebaseService().signOut();
                          Get.offAllNamed(RouteHelper.loginScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Sí, Salir",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navegarAInicioSegunRol() {
    if (Get.isRegistered<AuthMockController>()) {
      final auth = Get.find<AuthMockController>();
      if (auth.isClientDriver) {
        Get.offAllNamed(RouteHelper.sosConductorScreen);
      } else if (auth.isAssociateLawyer) {
        Get.offAllNamed(RouteHelper.lawyerWorkspaceScreen);
      } else {
        Get.offAllNamed(RouteHelper.legalCenterScreen);
      }
    } else {
      Get.offAllNamed(RouteHelper.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : Dimensions.paddingSizeDefault,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo e Icono de Menú
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (Get.isRegistered<MenuDrawerController>()) {
                        final ctrl = Get.find<MenuDrawerController>();
                        if (isDesktop) {
                          ctrl.toggleMenuDrawer();
                        } else {
                          ctrl.toggleMobileDrawer();
                        }
                      } else {
                        try {
                          Scaffold.of(context).openDrawer();
                        } catch (_) {}
                      }
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
                      child: GetBuilder<MenuDrawerController>(
                        builder: (menuCtrl) {
                          final isOpen = isDesktop
                              ? menuCtrl.isMenuDrawerExpanded
                              : menuCtrl.isMobileDrawerOpen;
                          return Icon(
                            isOpen ? Icons.menu_open_rounded : Icons.menu_rounded,
                            size: 20,
                            color: isOpen
                                ? (Theme.of(context).secondaryHeaderColor)
                                : Theme.of(context).textTheme.bodyLarge?.color,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _navegarAInicioSegunRol,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "LegalTech",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: isMobile ? 15 : 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (!isMobile) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D4ED8).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "24/7",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Acciones del lado derecho (Tema, Perfil y Cerrar Sesión)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Toggle Modo Oscuro / Claro
                  GetBuilder<ThemeController>(builder: (themeController) {
                    final isDark = themeController.darkTheme;
                    return Tooltip(
                      message: isDark ? "Cambiar a modo claro" : "Cambiar a modo oscuro",
                      child: InkWell(
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
                      ),
                    );
                  }),
                  SizedBox(width: isMobile ? 6 : 10),

                  // Botón Mi Perfil
                  Tooltip(
                    message: "Mi Perfil",
                    child: InkWell(
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
                  ),
                  SizedBox(width: isMobile ? 6 : 10),

                  // Botón Cerrar Sesión
                  Tooltip(
                    message: "Cerrar Sesión",
                    child: InkWell(
                      onTap: () => _mostrarDialogoCerrarSesion(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 36,
                        width: isDesktop ? null : 36,
                        padding: isDesktop
                            ? const EdgeInsets.symmetric(horizontal: 12)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                            if (isDesktop) ...[
                              const SizedBox(width: 6),
                              const Text(
                                "Salir",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ],
                        ),
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

