import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';

class CooperativeFilterChips extends StatelessWidget {
  const CooperativeFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        final counts = controller.cooperativeCounts;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeDefault,
            vertical: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt_rounded,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Filtro Rápido por Cooperativa de Taxis',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ubuntuBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${controller.filteredCases.length} casos mostrados',
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: controller.cooperatives.map((coop) {
                    final isSelected = controller.selectedCooperative == coop;
                    final count = counts[coop] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => controller.selectCooperative(coop),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (coop != 'Todas') ...[
                                Icon(
                                  Icons.local_taxi_rounded,
                                  size: 15,
                                  color: isSelected ? Colors.white : Colors.amber.shade800,
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                coop,
                                style: ubuntuMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyLarge!.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Theme.of(context).dividerColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$count',
                                  style: ubuntuBold.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyLarge!.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              // Buscador rápido
              TextField(
                controller: controller.searchController,
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Buscar por taxista, placa (ej: PBX), unidad o código...',
                  hintStyle: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  suffixIcon: controller.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).primaryColorLight.withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
