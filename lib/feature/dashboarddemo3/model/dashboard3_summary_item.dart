import 'package:getdash/utils/images.dart';

class DemoThreeSummaryItems {
  final String? amount;
  final String? increaseRate;
  final String? title;
  final String? subtitle;
  final String? image;

  DemoThreeSummaryItems(
      {this.amount, this.increaseRate, this.title,
      this.subtitle, this.image});
}


List demoThreeSummeryItems = [
  DemoThreeSummaryItems(
    amount: "100+",
    increaseRate: "27.36%",
    title: "Total Product",
    subtitle: " Since last month",
    image: Images.demo3profile
  ),
 
  DemoThreeSummaryItems(
    amount: "23,456",
    increaseRate: "27.36%",
    title: "Total Orders",
    subtitle: " Since last month",
    image: Images.demo3stat
  ),
 DemoThreeSummaryItems(
    amount: "100+",
    increaseRate: "27.36%",
    title: "Total Sales",
    subtitle: " Since last month",
    image: Images.demo3profile
  ),

   DemoThreeSummaryItems(
    amount: "23,456",
    increaseRate: "27.36%",
    title: "New Customers",
    subtitle: " Since last month",
    image: Images.demo3stat
  ),
];