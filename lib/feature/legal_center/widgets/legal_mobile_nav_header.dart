import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getdash/controller/theme_controller.dart';
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

  void _handleTabTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    HapticFeedback.lightImpact();

    final targetRoute = _tabs[index]['route'] as String;
    Get.offNamed(targetRoute);
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

                  const SizedBox(width: 10),

                  // Título e Identidad Legal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                fontSize: 15.5,
                                letterSpacing: 0.2,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D47A1).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Móvil Legal",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.5,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 1),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10.5,
                              color: isDark ? Colors.white60 : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Acciones Rápidas: Switch de Tema y Badge de Guardia
                  GetBuilder<ThemeController>(
                    builder: (themeController) {
                      return IconButton(
                        icon: Icon(
                          themeController.darkTheme
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          size: 20,
                          color: isDark ? Colors.amber : const Color(0xFF475569),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          themeController.toggleTheme();
                        },
                        tooltip: "Cambiar tema",
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),

                  // Acceso rápido a Portal Conductor SOS
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Get.offAllNamed(RouteHelper.getInitialRoute());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
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
                            Icon(Icons.sos_rounded, color: Color(0xFFDC2626), size: 14),
                            SizedBox(width: 3),
                            Text(
                              "SOS",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SELECTOR DE PESTAÑAS TIPO PILLS HORIZONTALES (THUMB FRIENDLY)
            if (showTabs)
              Container(
                height: 44,
                margin: const EdgeInsets.only(bottom: 6),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
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
              ),
          ],
        ),
      ),
    );
  }
}
