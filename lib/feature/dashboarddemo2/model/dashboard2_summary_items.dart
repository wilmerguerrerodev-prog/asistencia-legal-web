
import 'package:getdash/utils/images.dart';

class DemoOneSummeryItems {
  final String? amount;
  final String? increaseRate;
  final String? title;
  final String? image;

  DemoOneSummeryItems({
    this.amount,
    this.increaseRate,
    this.title,
    this.image,
  });
}


List demoOneSummeryItems = [
  DemoOneSummeryItems(
    amount: "70k",
    increaseRate: "25.5k",
    title: "Revenue",
    image: Images.dashboardshopcart,
  ),
  DemoOneSummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      title: "Growth",
    image: Images.dashboardstat,
  ),
  DemoOneSummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      title: "Order",
    image: Images.dashboardshopcart,
  ),
  DemoOneSummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      title: "Sales",
    image: Images.dashboarddollar,

  ),

];