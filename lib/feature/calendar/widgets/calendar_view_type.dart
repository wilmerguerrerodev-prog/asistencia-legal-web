import 'package:flutter/material.dart';
import 'package:getdash/core/helper/responsive_helper.dart';

import '../app_colors.dart';
import '../enumerations.dart';
import '../extension.dart';

class CalendarViewType extends StatelessWidget {
  final void Function(CalendarView view) onViewChange;
  final CalendarView currentView;

  const CalendarViewType({
    super.key,
    required this.onViewChange,
    this.currentView = CalendarView.month,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:ResponsiveHelper.isDesktop(context) ?  MainAxisAlignment.spaceBetween: MainAxisAlignment.start,
      children: List.generate(
        CalendarView.values.length,
            (index) {
          final view = CalendarView.values[index];
          return GestureDetector(
            onTap: () => onViewChange(view),
            child: Container(
              padding:EdgeInsets.symmetric(
                vertical: 10,
                horizontal: ResponsiveHelper.isMobile(context) ? 20:40,
              ),
              margin: const EdgeInsets.only(
                right: 20,
                top: 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: view == currentView
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: 0.09),
              ),
              child: Text(
                view.name.capitalized,
                style: TextStyle(
                  color: view == currentView
                      ? AppColors.white
                      : AppColors.black,
                  fontSize: 17,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
