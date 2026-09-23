
import 'package:flutter/material.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/utils/images.dart';

class MenuModel {
  String? icon;
  IconData? iconData;
  String? menuTitle;
  String? route;
  List<SubMenu>? subMenus;

  MenuModel({
    this.icon,
    this.iconData,
    this.menuTitle,
    this.route,
    this.subMenus,
  });
}

class SubMenu {
  String? subMenuTitle;
  String? route;

  SubMenu({
    required this.subMenuTitle,
    required this.route,
  });
}


 List<MenuModel> menuList = [
  MenuModel(
    icon: Images.dashboard,
    iconData: Icons.local_taxi_rounded,
    menuTitle: 'LegalTech Cliente',
    route: RouteHelper.getInitialRoute(),
  ),

  MenuModel(
    icon:Images.dashboard,
    menuTitle: 'Dashboard 1 Demo',
    route: RouteHelper.getDashboardScreen1(),
  ),

  MenuModel(
    icon:Images.dashboard,
    menuTitle: 'Dashboard 2 Demo',
    route: RouteHelper.getDashboardScreen2(),
  ),

  MenuModel(
    icon:Images.dashboard,
    menuTitle: 'Dashboard 3 Demo',
    route: RouteHelper.getDashboardScreen3(),
  ),


   MenuModel(
     menuTitle: 'features',
   ),


  MenuModel(
     icon:Images.dashboard,
     menuTitle: 'GetLearn',
     route: RouteHelper.getEdutechRoute(),
   ),

   MenuModel(
     icon:Images.calendar,
     menuTitle: 'Calendar',
     route: RouteHelper.getCalendarScreen(),
   ),
   MenuModel(
     icon:Images.googleMaps,
     menuTitle: 'Google Map',
     route: RouteHelper.getMapScreen(),
   ),
   MenuModel(
     icon:Images.chartsMenu,
     menuTitle: 'Charts',
     route: RouteHelper.getChartsScreen(),
   ),

   MenuModel(
     icon:Images.kanban,
     menuTitle: 'Kanban',
     route: RouteHelper.getKanbanScreen(),
   ),

   MenuModel(
     icon:Images.conversation,
     menuTitle: 'conversation',
     route: RouteHelper.getConversationScreen(),
   ),

  MenuModel(
      icon:Images.users,
      menuTitle:'manage_users',
      subMenus:[
        SubMenu(subMenuTitle: 'all_users_list',route: RouteHelper.getAllUsersScreen('')),
        SubMenu(subMenuTitle: 'add_user',route: RouteHelper.getAddUserScreen()),]),
  MenuModel(
      icon:Images.users,
      menuTitle:'manage_sellers',
      subMenus:[
        SubMenu(subMenuTitle: 'all_seller',route: RouteHelper.getAllSellerScreen('')),
        SubMenu(subMenuTitle: 'add_seller',route: RouteHelper.getAddSellerScreen()),]),
  MenuModel(
      icon:Images.contentManagement,
      menuTitle: 'manage_product',
      subMenus:[
        SubMenu(subMenuTitle: 'product_list',route: RouteHelper.getAllProductListScreen()),
        SubMenu(subMenuTitle: 'add_product',route: RouteHelper.getAddProductScreen()),
        SubMenu(subMenuTitle: 'product_details',route: RouteHelper.getProductDetailsScreen()),
      ]),

  MenuModel(
    icon:Images.mediaLibrary,
    menuTitle: 'media_library',
    route: RouteHelper.getMediaLibraryScreen(),
  ),
  MenuModel(
    icon:Images.paymentGateway,
    menuTitle: 'payment_gateway',
    route: RouteHelper.getPaymentGatewayScreen('url')
  ),
  MenuModel(
    icon:Images.smsAndOtp,
    menuTitle: 'sms_and_otp',
    route: RouteHelper.getSmsOtpScreen()
  ),
  MenuModel(
      icon:Images.pushNotification,
      menuTitle:'push_notification',
      subMenus:[
        SubMenu(subMenuTitle: 'send_notification',route: RouteHelper.getNotificationScreen()),
        SubMenu(subMenuTitle: 'create_notification',route: RouteHelper.getCreateNotificationScreen()),
        SubMenu(subMenuTitle: 'settings',route: RouteHelper.getNotificationSettingScreen()),]),
  MenuModel(
    icon:Images.pages,
    menuTitle: 'pages',
    route: RouteHelper.getAllPageScreen(),
  ),
  MenuModel(
    icon:Images.blog,
    menuTitle: 'blog',
      subMenus:[
        SubMenu(subMenuTitle: 'application_blogs',route: RouteHelper.getApplicationBlogScreen()),
        SubMenu(subMenuTitle: 'add_blog',route: RouteHelper.getAddBlogScreen()),]),

  MenuModel(
    icon:Images.refund,
    menuTitle: 'order_refunds',
    route: RouteHelper.getOrderRefundScreen(),
  ),
  MenuModel(
    icon:Images.support,
    menuTitle: 'support',
    route: RouteHelper.getSupportRoute()
  ),

  MenuModel(
      icon:Images.marketing,
      menuTitle:'marketing',
      subMenus:[
        SubMenu(subMenuTitle: 'subscribers',route: RouteHelper.getSubscriberScreen()),
        SubMenu(subMenuTitle: 'bulk_sms',route: RouteHelper.getBulkSmsScreen()),]),

  MenuModel(
      icon:Images.dashboard,
      menuTitle:'coupons',
      subMenus:[
        SubMenu(subMenuTitle: 'coupon_list',route: RouteHelper.getCouponScreenRoute()),
        SubMenu(subMenuTitle: 'add_new_coupon',route: RouteHelper.getAddCouponScreen()),
      ]),

  MenuModel(
      icon:Images.accounts,
      menuTitle:'accounts',
      subMenus:[
        SubMenu(subMenuTitle: 'transaction',route: RouteHelper.getTransactionScreen()),
        SubMenu(subMenuTitle: 'bank_accounts',route: RouteHelper.getBankAccountsScreen()),
        SubMenu(subMenuTitle: 'add_bank_account',route: RouteHelper.getAddBankAccountsScreen()),
        SubMenu(subMenuTitle: 'withdraw_requests',route: RouteHelper.getWithdrawRequestScreen()),
        SubMenu(subMenuTitle: 'delivery_men_earning',route: RouteHelper.getDeliveryManEarningScreen()),
      ]),

   MenuModel(
       icon:Images.reports,
       menuTitle:'report',
       subMenus:[
         SubMenu(subMenuTitle: 'sales_report',route: RouteHelper.getSalesReportScreen()),
         SubMenu(subMenuTitle: 'commission_history',route: RouteHelper.getCommissionHistoryScreen()),
         SubMenu(subMenuTitle: 'payment_history',route: RouteHelper.getPaymentHistoryScreen()),]),

   MenuModel(
       icon:Images.dashboard,
       menuTitle:'manage_employee',
       subMenus:[
         SubMenu(subMenuTitle: 'employee_list',route: RouteHelper.getEmployeeListScreen()),
         SubMenu(subMenuTitle: 'add_new_employee',route: RouteHelper.getAddEmployeeScreen()),
       ]),

   MenuModel(
       icon:Images.setup,
       menuTitle:'authentication',
       subMenus:[
         SubMenu(subMenuTitle: 'login_screen',route: RouteHelper.getLoginScreen()),
         SubMenu(subMenuTitle: 'registration_screen',route: RouteHelper.getRegistrationScreen()),]),

];
