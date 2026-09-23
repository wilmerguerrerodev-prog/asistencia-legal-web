import 'package:getdash/utils/images.dart';

class OrderSummeryItems {
  final String? amount;
  final String? title;
  final String? iconPath;

  OrderSummeryItems({
    this.amount,
    this.title,
    this.iconPath,
  });
}


List orderSummeryItems = [
  OrderSummeryItems(
    amount: "18",
    title: "Total Orders",
    iconPath: Images.totalOrders,
  ),
  OrderSummeryItems(
    amount: "18",
    title: "Total Pending",
    iconPath: Images.pendingOrder,
  ),
  OrderSummeryItems(
    amount: "18",
    title: "Total Processing",
    iconPath: Images.orderProcessing,
  ),
  OrderSummeryItems(
    amount: "18",
    title: "Total Delivered",
    iconPath: Images.totalDelivered,
  ),

];