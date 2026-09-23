import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';
import '../controller/legal_center_controller.dart';

class LegalKpiHeader extends StatelessWidget {
  const LegalKpiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return GetBuilder<LegalCenterController>(
      builder: (controller) {
        final cards = [
          _buildKpiCard(
            context: context,
            title: 'Casos Registrados Hoy',
            value: '${controller.totalCasesCount}',
            subtitle: 'En monitoreo legal activo',
            icon: Icons.assignment_outlined,
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF1976D2),
          ),
          _buildKpiCard(
            context: context,
            title: 'Urgencia Alta (Pendientes)',
            value: '${controller.urgentPendingCasesCount}',
            subtitle: controller.urgentPendingCasesCount > 0
                ? 'Requieren acción inmediata'
                : 'Bajo control',
            icon: Icons.emergency_rounded,
            iconBgColor: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFD32F2F),
            isAlert: controller.urgentPendingCasesCount > 0,
          ),
          _buildKpiCard(
            context: context,
            title: 'Abogados en Territorio',
            value: '${controller.dispatchedCount}',
            subtitle: 'Unidades móviles en camino',
            icon: Icons.directions_car_filled_rounded,
            iconBgColor: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF2E7D32),
          ),
          _buildKpiCard(
            context: context,
            title: 'Flota Mayor Incidencia',
            value: controller.topCooperative,
            valueIsText: true,
            subtitle: 'Cooperativa prioritaria',
            icon: Icons.local_taxi_rounded,
            iconBgColor: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFE65100),
          ),
        ];

        if (isMobile) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            childAspectRatio: 1.15,
            children: cards,
          );
        }

        return Row(
          children: cards.map((card) => Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: card,
          ))).toList(),
        );
      },
    );
  }

  Widget _buildKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    bool isAlert = false,
    bool valueIsText = false,
  }) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Container(
      padding: EdgeInsets.all(isMobile ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: isAlert
              ? const Color(0xFFEF5350).withValues(alpha: 0.5)
              : Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: isAlert ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isAlert
                ? const Color(0xFFEF5350).withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: ubuntuMedium.copyWith(
                    fontSize: isMobile ? 11 : Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: 0.75),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: isMobile ? 16 : 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: ubuntuBold.copyWith(
              fontSize: valueIsText ? (isMobile ? 13 : Dimensions.fontSizeDefault) : (isMobile ? 20 : Dimensions.fontSizeOverLarge),
              color: isAlert ? const Color(0xFFD32F2F) : Theme.of(context).textTheme.bodyLarge!.color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: ubuntuRegular.copyWith(
              fontSize: isMobile ? 9 : Dimensions.fontSizeExtraSmall,
              color: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
