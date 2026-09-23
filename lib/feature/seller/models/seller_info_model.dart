import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerInfoModel {
  final IconData? leadingIcon;
  final String? title;
  final int? totalSellerAmount;
  final int? totalSales;

  SellerInfoModel({
    this.leadingIcon,
    this.title,
    this.totalSellerAmount,
    this.totalSales,
  });
}


List sellerInfoList = [
  SellerInfoModel(
    leadingIcon: Icons.account_balance_outlined,
    title: "total_seller".tr,
    totalSellerAmount: 5000,
    totalSales: 10,
  ),
  SellerInfoModel(
    leadingIcon: Icons.thumb_up_alt_outlined,
    title: "approved_seller".tr,
    totalSellerAmount: 5000,
    totalSales: 10,
  ),
  SellerInfoModel(
    leadingIcon: Icons.hourglass_top_outlined,
    title: "pending_seller".tr,
    totalSellerAmount: 200,
    totalSales: 10,
  ),
  SellerInfoModel(
    leadingIcon: Icons.block_outlined,
    title: "inactive_seller".tr,
    totalSellerAmount: 800,
    totalSales: 10,
  ),


];