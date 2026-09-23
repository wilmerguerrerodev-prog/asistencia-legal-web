import 'dart:ui';

class SummeryItems {
  final String? amount;
  final String? increaseRate;
  final Color? color;

  SummeryItems({
    this.amount,
    this.increaseRate,
    this.color,
});
}


List summeryItems = [
  SummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      color: const Color(0xff489AB4)
  ),
  SummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      color: const Color(0xff6BC063)
  ),
  SummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      color: const Color(0xffAF78DA)
  ),
  SummeryItems(
      amount: "450K",
      increaseRate: "25.5k",
      color: const Color(0xff4EBEE1)
  ),

];