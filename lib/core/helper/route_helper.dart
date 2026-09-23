import 'package:get/get.dart';
import 'package:getdash/feature/accounting/add_bank_account_screen.dart';
import 'package:getdash/feature/accounting/bank_accounts_screen.dart';
import 'package:getdash/feature/accounting/delivery_man_earning_screen.dart';
import 'package:getdash/feature/accounting/transactions_screen.dart';
import 'package:getdash/feature/accounting/withdraw_request_screen.dart';
import 'package:getdash/feature/all_page/all_page_screen.dart';
import 'package:getdash/feature/blog_post/add_blog_screen.dart';
import 'package:getdash/feature/blog_post/application_blog_screen.dart';
import 'package:getdash/feature/calendar/calendar_screen.dart';
import 'package:getdash/feature/charts/charts_screen.dart';
import 'package:getdash/feature/conversation/view/conversation_details_mobile.dart';
import 'package:getdash/feature/conversation/view/conversation_screen.dart';
import 'package:getdash/feature/coupons/add_coupon_screen.dart';
import 'package:getdash/feature/coupons/coupon_screen.dart';
import 'package:getdash/feature/auth/view/login_screen.dart';
import 'package:getdash/feature/auth/view/registration_screen.dart';
import 'package:getdash/feature/dashboarddemo1/dahboard_screen_demo1.dart';
import 'package:getdash/feature/dashboarddemo2/dashboard_screen_demo2.dart';
import 'package:getdash/feature/dashboarddemo3/dashboard_screeen_demo3.dart';
import 'package:getdash/feature/kanban_board/kanban_screen.dart';
import 'package:getdash/feature/manage_employee/add_employee_screen.dart';
import 'package:getdash/feature/manage_employee/employee_list_screen.dart';
import 'package:getdash/feature/maps/map_screen.dart';
import 'package:getdash/feature/marketing/bulk_sms_screen.dart';
import 'package:getdash/feature/marketing/subscriber_screen.dart';
import 'package:getdash/feature/notification/view/create_notificaion_screen.dart';
import 'package:getdash/feature/notification/view/notificaion_settings.dart';
import 'package:getdash/feature/notification/view/send_notification_screen.dart';
import 'package:getdash/feature/order_refunds/order_refunds_screen.dart';
import 'package:getdash/feature/otp/sms_otp_setting_screen.dart';
import 'package:getdash/feature/payment_gateway/payment_gateway_screen.dart';
import 'package:getdash/feature/product/add_product_screen.dart';
import 'package:getdash/feature/product/product_details_screen.dart';
import 'package:getdash/feature/product/product_list_screen.dart';
import 'package:getdash/feature/push_notification/push_notification_screen.dart';
import 'package:getdash/feature/push_notification/push_notification_setting_screen.dart';
import 'package:getdash/feature/report/commission_history_screen.dart';
import 'package:getdash/feature/report/payment_history_screen.dart';
import 'package:getdash/feature/report/sales_report_screen.dart';
import 'package:getdash/feature/seller/add_seller_screen.dart';
import 'package:getdash/feature/seller/seller_details_screen.dart';
import 'package:getdash/feature/seller/all_seller_screen.dart';
import 'package:getdash/feature/sms/sms_template_screen.dart';
import 'package:getdash/feature/dashboard/dashboard_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_center_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_cases_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_lawyers_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_cooperatives_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_documents_screen.dart';
import 'package:getdash/feature/media_library/media_library_screen.dart';
import 'package:getdash/feature/support/support_screen.dart';
import 'package:getdash/feature/users/add_user_screen.dart';
import 'package:getdash/feature/users/all_users.dart';
import 'package:getdash/feature/conductor/sos_conductor_view.dart';
import 'package:getdash/feature/users/user_profile_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String sosConductorScreen = '/sos';
  static const String forgotPassword = '/forgot-password';
  static const String supportScreen = '/help-and-support';
  static const String couponScreen = '/couponScreen';
  static const String addCouponScreen = '/addCouponScreen';
  static const String paymentGatewayScreen = '/paymentGatewayScreen';
  static const String allUsersScreen = '/allUsersScreen';
  static const String addUserScreen = '/addUserScreen';
  static const String userProfileScreen = '/userProfileScreen';
  static const String allSellerScreen = '/allSellerScreen';
  static const String sellerDetailsScreen = '/sellerDetailsScreen';
  static const String addSellerScreen = '/addSellerScreen';
  static const String mediaLibraryScreen = '/mediaLibraryScreen';
  static const String smsOtpSettingScreen = '/smsOtpSettingScreen';
  static const String smsTemplateScreen = '/smsTemplateScreen';
  static const String pushNotificationSettingScreen =
      '/pushNotificationSettingScreen';
  static const String pushNotificationScreen = '/pushNotificationScreen';
  static const String applicationBlogScreen = '/applicationBlogScreen';
  static const String addBlogScreen = '/addBlogScreen';
  static const String allPageScreen = '/allPageScreen';
  static const String bulkSmsScreen = '/bulkSmsScreen';
  static const String subscriberScreen = '/subscriberScreen';
  static const String transactionScreen = '/transactionScreen';
  static const String bankAccountsScreen = '/bankAccountsScreen';
  static const String addBankAccountsScreen = '/addBankAccountsScreen';
  static const String withdrawRequestScreen = '/withdrawRequestScreen';
  static const String deliveryManEarningScreen = '/deliveryManEarningScreen';
  static const String addEmployeeScreen = '/addEmployeeScreen';
  static const String employeeListScreen = '/employeeListScreen';
  static const String loginScreen = '/loginScreen';
  static const String registrationScreen = '/registrationScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String productListScreen = '/productListScreen';
  static const String addProductScreen = '/addProductScreen';
  static const String notificationScreen = '/notificationScreen';
  static const String createNotificationScreen = '/createNotificationScreen';
  static const String notificationSettingScreen = '/notificationSettingScreen';
  static const String orderRefundScreen = '/orderRefundScreen';
  static const String salesReportScreen = '/salesReportScreen';
  static const String commissionHistoryScreen = '/commissionHistoryScreen';
  static const String paymentHistoryScreen = '/paymentHistoryScreen';
  static const String calendarScreen = '/calendarScreen';
  static const String mapScreen = '/mapScreen';
  static const String chartsScreen = '/chartsScreen';
  static const String kanbanScreen = '/kanbanScreen';
  static const String conversationScreen = '/conversationScreen';
  static const String conversationScreenMobile = '/conversationScreenMobile';
  static const String edutechScreen = '/WeblandingPage';
  static const String legalCenterScreen = '/WeblandingPage';
  static const String legalCasesScreen = '/legalCases';
  static const String legalLawyersScreen = '/legalLawyers';
  static const String legalCooperativesScreen = '/legalCooperatives';
  static const String legalDocumentsScreen = '/legalDocuments';
  static const String dashboardScreen1 = '/DashboardScreen1';
  static const String dashboardScreen2 = '/DashboardDemoScreen2';
  static const String dashboardScreen3 = '/DashboardDemoScreen3';

  static String getInitialRoute() => initial;
  static String getSupportRoute() => supportScreen;
  static String getCouponScreenRoute() => couponScreen;
  static String getForgotPassRoute() => forgotPassword;
  static String getPaymentGatewayScreen(String url) =>
      '$paymentGatewayScreen?url=$url';
  static String getAllUsersScreen(String fromPage) =>
      '$allUsersScreen?fromPage=$fromPage';
  static String getAddUserScreen() => addUserScreen;
  static String getUserProfileScreen() => userProfileScreen;
  static String getAllSellerScreen(String fromPage) => allSellerScreen;
  static String getAddSellerScreen() => addSellerScreen;
  static String getMediaLibraryScreen() => mediaLibraryScreen;
  static String getSmsOtpScreen() => smsOtpSettingScreen;
  static String getApplicationBlogScreen() => applicationBlogScreen;
  static String getAllPageScreen() => allPageScreen;
  static String getBulkSmsScreen() => bulkSmsScreen;
  static String getSubscriberScreen() => subscriberScreen;
  static String getTransactionScreen() => transactionScreen;
  static String getBankAccountsScreen() => bankAccountsScreen;
  static String getAddBankAccountsScreen() => addBankAccountsScreen;
  static String getWithdrawRequestScreen() => withdrawRequestScreen;
  static String getDeliveryManEarningScreen() => deliveryManEarningScreen;
  static String getAddEmployeeScreen() => addEmployeeScreen;
  static String getEmployeeListScreen() => employeeListScreen;
  static String getLoginScreen() => loginScreen;
  static String getRegistrationScreen() => registrationScreen;
  static String getAddCouponScreen() => addCouponScreen;
  static String getAddBlogScreen() => addBlogScreen;
  static String getProductDetailsScreen() => productDetailsScreen;
  static String getAllProductListScreen() => productListScreen;
  static String getAddProductScreen() => addProductScreen;
  static String getNotificationScreen() => notificationScreen;
  static String getCreateNotificationScreen() => createNotificationScreen;
  static String getNotificationSettingScreen() => notificationSettingScreen;
  static String getOrderRefundScreen() => orderRefundScreen;
  static String getSalesReportScreen() => salesReportScreen;
  static String getCommissionHistoryScreen() => commissionHistoryScreen;
  static String getPaymentHistoryScreen() => paymentHistoryScreen;
  static String getCalendarScreen() => calendarScreen;
  static String getMapScreen() => mapScreen;
  static String getChartsScreen() => chartsScreen;
  static String getKanbanScreen() => kanbanScreen;
  static String getConversationScreen() => conversationScreen;
  static String getConversationScreenMobile() => conversationScreenMobile;
  static String getEdutechRoute() => edutechScreen;
  static String getLegalCenterRoute() => legalCenterScreen;
  static String getLegalCasesRoute() => legalCasesScreen;
  static String getLegalLawyersRoute() => legalLawyersScreen;
  static String getLegalCooperativesRoute() => legalCooperativesScreen;
  static String getLegalDocumentsRoute() => legalDocumentsScreen;
  static String getDashboardScreen1() => dashboardScreen1;
  static String getDashboardScreen2() => dashboardScreen2;
  static String getDashboardScreen3() => dashboardScreen3;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen()),
    GetPage(name: sosConductorScreen, page: () => const SosConductorView()),
    GetPage(name: dashboardScreen1, page:()=> const DashboardScreen1()),
    GetPage(name: dashboardScreen2, page:()=> const DashboardDemoScreen2()),
    GetPage(name: dashboardScreen3, page:()=> const DashboardDemoScreen3()),
    GetPage(name: allUsersScreen, page: () => const AllUsersScreen()),
    GetPage(name: addUserScreen, page: () => const AddUserScreen()),
    GetPage(name: userProfileScreen, page: () => const UserProfile()),
    GetPage(name: allSellerScreen, page: () => const AllSellerScreen()),
    GetPage(name: sellerDetailsScreen, page: () => const SellerDetailsScreen()),
    GetPage(name: addSellerScreen, page: () => const AddSellerScreen()),
    GetPage(name: mediaLibraryScreen, page: () => MediaLibraryScreen()),
    GetPage(name: smsOtpSettingScreen, page: () => const SmsOtpSettingScreen()),
    GetPage(name: smsTemplateScreen, page: () => const SmsTemplateScreen()),
    GetPage(
        name: pushNotificationSettingScreen,
        page: () => const PushNotificationSettingScreen()),
    GetPage(
        name: pushNotificationScreen,
        page: () => const PushNotificationScreen()),
    GetPage(
        name: applicationBlogScreen, page: () => const ApplicationBlogScreen()),
    GetPage(name: allPageScreen, page: () => const AllPageScreen()),
    GetPage(name: bulkSmsScreen, page: () => const BulkSmsScreen()),
    GetPage(name: subscriberScreen, page: () => const SubscriberScreen()),
    GetPage(name: transactionScreen, page: () => const TransactionScreen()),
    GetPage(name: bankAccountsScreen, page: () => const BankAccountScreen()),
    GetPage(
        name: addBankAccountsScreen, page: () => const AddBankAccountScreen()),
    GetPage(
        name: withdrawRequestScreen, page: () => const WithdrawRequestScreen()),
    GetPage(
        name: deliveryManEarningScreen,
        page: () => const DeliveryManEarningScreen()),
    GetPage(name: addEmployeeScreen, page: () => const AddEmployeeScreen()),
    GetPage(name: employeeListScreen, page: () => const EmployeeListScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),
    GetPage(
        name: paymentGatewayScreen, page: () => const PaymentGatewayScreen()),
    GetPage(
      name: couponScreen,
      page: () => const CouponScreen(),
    ),
    GetPage(
      name: addCouponScreen,
      page: () => const AddCouponScreen(),
    ),
    GetPage(
      name: addBlogScreen,
      page: () => const AddBlogScreen(),
    ),
    GetPage(
        name: productDetailsScreen, page: () => const ProductDetailsScreen()),
    GetPage(name: productListScreen, page: () => const ProductListScreen()),
    GetPage(name: addProductScreen, page: () => const AddProductScreen()),
    GetPage(
        name: notificationScreen, page: () => const SendNotificationScreen()),
    GetPage(
        name: createNotificationScreen,
        page: () => const CreateNotificationScreen()),
    GetPage(
        name: notificationSettingScreen,
        page: () => const NotificationSettingScreen()),
    GetPage(name: orderRefundScreen, page: () => const OrderRefundScreen()),
    GetPage(name: salesReportScreen, page: () => const SalesReportScreen()),
    GetPage(
        name: commissionHistoryScreen,
        page: () => const CommissionHistoryScreen()),
    GetPage(
        name: paymentHistoryScreen, page: () => const PaymentHistoryScreen()),
    GetPage(name: supportScreen, page: () => const SupportScreen()),
    GetPage(name: calendarScreen, page: () => const CalendarScreen()),
    GetPage(name: mapScreen, page: () => MapScreen()),
    GetPage(name: chartsScreen, page: () => const ChartsScreen()),
    GetPage(name: kanbanScreen, page: () => const KanbanScreen()),
    GetPage(
        name: conversationScreen,
        page: () => const ConversationScreen(
            name: "name",
            image: "image",
            channelID: "channelID",
            date: "date",
            bookingID: "bookingID")),

    GetPage(
        name: conversationScreenMobile,
        page: () => const ConversationScreenMobile(
            name: "name",
            image: "image",
            channelID: "channelID",
            date: "date",
            bookingID: "bookingID")),

    GetPage(
        name: edutechScreen,
        page: () => const LegalCenterScreen()),
    GetPage(
        name: legalCasesScreen,
        page: () => const LegalCasesScreen()),
    GetPage(
        name: legalLawyersScreen,
        page: () => const LegalLawyersScreen()),
    GetPage(
        name: legalCooperativesScreen,
        page: () => const LegalCooperativesScreen()),
    GetPage(
        name: legalDocumentsScreen,
        page: () => const LegalDocumentsScreen()),
  ];
}
