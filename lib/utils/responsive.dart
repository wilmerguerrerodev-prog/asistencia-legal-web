import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveWidget({super.key, required this.mobile, required this.tablet, required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return LayoutBuilder(builder: (context, constraints) {
      if (size.width >= 1100) {
        return desktop;
      } else if (size.width < 1100 && size.width >= 850) {
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
