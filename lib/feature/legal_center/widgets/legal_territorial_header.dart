import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';

class LegalTerritorialHeader extends StatelessWidget {
  const LegalTerritorialHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA SUPERIOR: FILTROS TERRITORIALES EN CASCADA
            _buildCascadingFilterBar(context, controller, isMobile),

            const SizedBox(height: 12),

            // 3 CONTADORES RÁPIDOS (KPI CARDS) COMPACTOS
            _buildKpiCardsRow(context, controller, isMobile),
          ],
        );
      },
    );
  }

  // --- FILTRO TERRITORIAL EN CASCADA ---
  Widget _buildCascadingFilterBar(
    BuildContext context,
    LegalCenterController controller,
    bool isMobile,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtítulo ejecutivo y switch de auto-despacho GPS
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.travel_explore_rounded, size: 16, color: Color(0xFF1565C0)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Filtro Territorial en Cascada',
                        style: ubuntuBold.copyWith(
                          fontSize: isMobile ? 11 : Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _buildAutoDispatchToggle(context, controller, isMobile),
              if (controller.selectedProvince != 'Imbabura' ||
                  controller.selectedCanton != 'Todos' ||
                  controller.selectedCooperative != 'Todas' ||
                  controller.searchQuery.isNotEmpty) ...[
                const SizedBox(width: 6),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 13),
                  label: const Text('Reset', style: TextStyle(fontSize: 10)),
                  onPressed: () => controller.resetFilters(),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),

          // Selectores en Cascada
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // 1. PAÍS: ECUADOR (FIJO)
              _buildFixedCountryBadge(context, controller),

              // 2. DROPDOWN PROVINCIA
              _buildDropdown(
                context: context,
                label: 'Provincia',
                icon: Icons.map_outlined,
                value: controller.selectedProvince,
                items: controller.provinces,
                onChanged: (val) {
                  if (val != null) controller.selectProvince(val);
                },
              ),

              // 3. DROPDOWN CANTÓN
              _buildDropdown(
                context: context,
                label: 'Cantón',
                icon: Icons.location_city_outlined,
                value: controller.selectedCanton,
                items: controller.availableCantons,
                onChanged: (val) {
                  if (val != null) controller.selectCanton(val);
                },
              ),

              // 4. DROPDOWN COOPERATIVA / FLOTA
              _buildDropdown(
                context: context,
                label: 'Cooperativa / Flota',
                icon: Icons.local_taxi_outlined,
                value: controller.selectedCooperative,
                items: controller.cooperatives,
                onChanged: (val) {
                  if (val != null) controller.selectCooperative(val);
                },
              ),

              // 5. BUSCADOR DIRECTO
              _buildSearchInput(context, controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFixedCountryBadge(
    BuildContext context,
    LegalCenterController controller,
  ) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇪🇨', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'País',
                style: ubuntuRegular.copyWith(
                  fontSize: 9,
                  height: 1.1,
                  color: Theme.of(context).hintColor,
                ),
              ),
              Text(
                controller.selectedCountry,
                style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  height: 1.1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.lock_outline_rounded,
            size: 13,
            color: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).hintColor),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: ubuntuRegular.copyWith(
                  fontSize: 9,
                  height: 1.1,
                  color: Theme.of(context).hintColor,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: items.contains(value) ? value : items.first,
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 16),
                  style: ubuntuBold.copyWith(
                    fontSize: 11,
                    height: 1.1,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(
    BuildContext context,
    LegalCenterController controller,
  ) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return SizedBox(
      width: isMobile ? double.infinity : 220,
      height: 42,
      child: TextField(
        controller: controller.searchController,
        onChanged: (val) => controller.setSearchQuery(val),
        style: ubuntuRegular.copyWith(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Buscar conductor, placa...',
          hintStyle: ubuntuRegular.copyWith(fontSize: 11, color: Theme.of(context).hintColor),
          prefixIcon: const Icon(Icons.search, size: 16),
          suffixIcon: controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 14),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.setSearchQuery('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // --- 3 CONTADORES RÁPIDOS (KPI CARDS) COMPACTOS ---
  Widget _buildKpiCardsRow(
    BuildContext context,
    LegalCenterController controller,
    bool isMobile,
  ) {
    final kpiCards = [
      // 1. 🔴 URGENTES / CÓDIGO ROJO
      _buildCompactKpiCard(
        context: context,
        title: 'Código Rojo / Urgentes',
        count: controller.redCodeCount,
        subtitle: 'Heridos o retenciones activas',
        badgeColor: const Color(0xFFD32F2F),
        bgColor: const Color(0xFFFFEBEE),
        icon: Icons.emergency_rounded,
        isActive: controller.activeKpiFilter == 'rojo',
        onTap: () => controller.toggleKpiFilter('rojo'),
      ),

      // 2. 🟡 PENDIENTES DE ATENCIÓN
      _buildCompactKpiCard(
        context: context,
        title: 'Pendientes de Atención',
        count: controller.pendingAttentionCount,
        subtitle: 'En espera de abogado en vía',
        badgeColor: const Color(0xFFF57C00),
        bgColor: const Color(0xFFFFF3E0),
        icon: Icons.hourglass_top_rounded,
        isActive: controller.activeKpiFilter == 'pendiente',
        onTap: () => controller.toggleKpiFilter('pendiente'),
      ),

      // 3. 🟢 ATENDIDOS / EN PROCESO
      _buildCompactKpiCard(
        context: context,
        title: 'Atendidos / En Proceso',
        count: controller.inProcessOrSolvedCount,
        subtitle: 'Abogado despachado o resuelto',
        badgeColor: const Color(0xFF2E7D32),
        bgColor: const Color(0xFFE8F5E9),
        icon: Icons.task_alt_rounded,
        isActive: controller.activeKpiFilter == 'proceso',
        onTap: () => controller.toggleKpiFilter('proceso'),
      ),
    ];

    if (isMobile) {
      return Column(
        children: kpiCards
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: card,
                ))
            .toList(),
      );
    }

    return Row(
      children: kpiCards
          .map((card) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: card,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCompactKpiCard({
    required BuildContext context,
    required String title,
    required int count,
    required String subtitle,
    required Color badgeColor,
    required Color bgColor,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? badgeColor : Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? badgeColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: isActive ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: badgeColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          title,
                          style: ubuntuBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: ubuntuRegular.copyWith(
                      fontSize: 10,
                      color: Theme.of(context).hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count',
              style: ubuntuBold.copyWith(
                fontSize: 22,
                color: badgeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoDispatchToggle(BuildContext context, LegalCenterController controller, bool isMobile) {
    final isAuto = controller.autoDispatchEnabled;
    return Tooltip(
      message: isAuto
          ? 'Despacho inteligente activo: asigna automáticamente al abogado disponible más cercano mediante GPS.'
          : 'Despacho pausado: los nuevos casos requerirán asignación manual por el operador.',
      child: InkWell(
        onTap: () => controller.toggleAutoDispatch(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 7 : 10,
            vertical: 3.5,
          ),
          decoration: BoxDecoration(
            color: isAuto
                ? const Color(0xFF1B5E20).withValues(alpha: 0.1)
                : const Color(0xFF455A64).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAuto
                  ? const Color(0xFF2E7D32).withValues(alpha: 0.5)
                  : Colors.grey.shade400,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAuto ? Icons.bolt_rounded : Icons.pause_circle_outline_rounded,
                size: 13,
                color: isAuto ? const Color(0xFF2E7D32) : Colors.blueGrey,
              ),
              const SizedBox(width: 4),
              Text(
                isMobile
                    ? (isAuto ? 'Auto GPS: ON' : 'Manual')
                    : (isAuto ? 'Auto-Despacho GPS: ON' : 'Despacho: MANUAL'),
                style: ubuntuBold.copyWith(
                  fontSize: isMobile ? 9.5 : 10.5,
                  color: isAuto ? const Color(0xFF1B5E20) : Colors.blueGrey.shade800,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAuto ? const Color(0xFF2E7D32) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
