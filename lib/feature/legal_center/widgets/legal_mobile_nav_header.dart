import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/theme_controller.dart';
import 'package:getdash/core/auth/controller/auth_mock_controller.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/helper/route_helper.dart';

class LegalMobileNavHeader extends StatelessWidget implements PreferredSizeWidget {
  final int activeIndex;
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showTabs;

  const LegalMobileNavHeader({
    super.key,
    required this.activeIndex,
    required this.title,
    this.subtitle,
    this.onBack,
    this.showTabs = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(showTabs ? 116 : 64);

  static const List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Monitor',
      'icon': Icons.dashboard_rounded,
      'route': RouteHelper.edutechScreen,
    },
    {
      'title': 'Siniestros',
      'icon': Icons.car_crash_rounded,
      'route': RouteHelper.legalCasesScreen,
    },
    {
      'title': 'Abogados',
      'icon': Icons.balance_rounded,
      'route': RouteHelper.legalLawyersScreen,
    },
    {
      'title': 'Cooperativas',
      'icon': Icons.local_taxi_rounded,
      'route': RouteHelper.legalCooperativesScreen,
    },
    {
      'title': 'Dictámenes',
      'icon': Icons.description_rounded,
      'route': RouteHelper.legalDocumentsScreen,
    },
  ];

  List<Map<String, dynamic>> _getTabs() {
    final isAssociate = Get.isRegistered<AuthMockController>() &&
        Get.find<AuthMockController>().isAssociateLawyer;
    if (isAssociate) {
      return const [
        {
          'title': 'Mi Despacho',
          'icon': Icons.shield_rounded,
          'route': RouteHelper.lawyerWorkspaceScreen,
        },
        {
          'title': 'Dictámenes & Actas',
          'icon': Icons.description_rounded,
          'route': RouteHelper.legalDocumentsScreen,
        },
      ];
    }
    return _tabs;
  }

  void _handleTabTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    HapticFeedback.lightImpact();

    final tabs = _getTabs();
    if (index < tabs.length) {
      final targetRoute = tabs[index]['route'] as String;
      Get.offNamed(targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // BARRA SUPERIOR MÓVIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  // Botón de Volver o Inicio
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if (onBack != null) {
                          onBack!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(RouteHelper.getInitialRoute());
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Título e Identidad Legal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                            letterSpacing: 0.1,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 1),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Acciones Rápidas derechas
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge interactivo de Rol Actual (Cambio rápido)
                      if (Get.isRegistered<AuthMockController>())
                        GetBuilder<AuthMockController>(
                          builder: (auth) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => _showRoleSwitcherSheet(context, auth),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D4ED8)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFF1D4ED8)
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(auth.user.role.iconEmoji,
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 3),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 80),
                                        child: Text(
                                          auth.user.role.shortBadge,
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9.5,
                                            color: Color(0xFF1D4ED8),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      const SizedBox(width: 2),

                      // Switch de Tema
                      GetBuilder<ThemeController>(
                        builder: (themeController) {
                          return IconButton(
                            icon: Icon(
                              themeController.darkTheme
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              size: 18,
                              color: isDark ? Colors.amber : const Color(0xFF475569),
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              themeController.toggleTheme();
                            },
                            tooltip: "Cambiar tema",
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          );
                        },
                      ),

                      // Acceso rápido a Portal Conductor SOS (visible si ancho >= 365px)
                      if (MediaQuery.of(context).size.width >= 365) ...[
                        const SizedBox(width: 2),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.offAllNamed(RouteHelper.getInitialRoute());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sos_rounded, color: Color(0xFFDC2626), size: 13),
                                  SizedBox(width: 2),
                                  Text(
                                    "SOS",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // SELECTOR DE PESTAÑAS TIPO PILLS HORIZONTALES (THUMB FRIENDLY)
            if (showTabs)
              Builder(
                builder: (context) {
                  final activeTabs = _getTabs();

                  return Container(
                    height: 44,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: activeTabs.length,
                      itemBuilder: (context, index) {
                        final tab = activeTabs[index];
                        final isSelected = index == activeIndex;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => _handleTabTap(context, index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : isDark
                                        ? const Color(0xFF334155)
                                        : const Color(0xFFCBD5E1),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1D4ED8).withValues(alpha: 0.35),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  tab['icon'] as IconData,
                                  size: 15,
                                  color: isSelected
                                      ? Colors.white
                                      : isDark
                                          ? Colors.white70
                                          : const Color(0xFF475569),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  tab['title'] as String,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : isDark
                                            ? Colors.white70
                                            : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

  void _showRoleSwitcherSheet(BuildContext context, AuthMockController auth) {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(sheetCtx).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Barra de arrastre superior
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

              // Encabezado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D4ED8).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.switch_account_rounded,
                      color: Color(0xFF1D4ED8),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Simulador de Roles (RBAC)",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Selecciona un perfil para validar permisos y vistas:",
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: isDark ? Colors.white60 : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Opciones de Roles
              ...UserRole.values.map((role) {
                final isSelected = auth.role == role;
                String userDesc = '';
                switch (role) {
                  case UserRole.itAdmin:
                    userDesc = "Ing. Admin Sistemas • Logs técnicos y configuración";
                    break;
                  case UserRole.adminLawyer:
                    userDesc = "Dr. Emir Vásquez • Despacho central y monitor";
                    break;
                  case UserRole.associateLawyer:
                    userDesc = "Dra. Andrea Morales • Mi Despacho y casos asignados";
                    break;
                  case UserRole.clientDriver:
                    userDesc = "Carlos Mendoza • Portal Conductor SOS Unidad #42";
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(sheetCtx);
                        auth.switchRole(role);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1D4ED8).withValues(alpha: isDark ? 0.22 : 0.08)
                              : isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1D4ED8)
                                : isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.8 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1D4ED8).withValues(alpha: 0.15)
                                    : (isDark ? const Color(0xFF0F172A) : Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  role.iconEmoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          role.displayName,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: isSelected
                                                ? const Color(0xFF1D4ED8)
                                                : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 1.5),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1D4ED8),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            "ACTIVO",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w800,
                                              fontSize: 8.5,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    userDesc,
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 11.5,
                                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF1D4ED8),
                                size: 22,
                              )
                            else
                              Icon(
                                Icons.chevron_right_rounded,
                                color: isDark ? Colors.white24 : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
}

