import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../model/event.dart';

class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;

  const WeekViewWidget({Key? key, this.state, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<Event>(
      headerStyle: HeaderStyle(
          decoration: BoxDecoration(
            color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.03),
          )
      ),
      key: state,
    );
  }
}
