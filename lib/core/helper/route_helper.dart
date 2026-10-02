import 'package:get/get.dart';
import 'package:getdash/feature/auth/view/change_temporary_password_screen.dart';
import 'package:getdash/feature/auth/view/login_screen.dart';
import 'package:getdash/feature/auth/view/registration_screen.dart';
import 'package:getdash/feature/conductor/suscripcion_conductor_screen.dart';
import 'package:getdash/feature/dashboard/dashboard_screen.dart';
import 'package:getdash/feature/legal_center/view/lawyer_workspace_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_cases_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_center_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_cooperatives_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_documents_screen.dart';
import 'package:getdash/feature/legal_center/view/legal_lawyers_screen.dart';
import 'package:getdash/feature/subscriptions/view/admin_subscriptions_screen.dart';
import 'package:getdash/feature/users/user_profile_screen.dart';

class RouteHelper {
  // Rutas de Autenticación y Perfil
  static const String initial = '/';
  static const String loginScreen = '/loginScreen';
  static const String registrationScreen = '/registrationScreen';
  static const String changeTemporaryPasswordScreen = '/changeTemporaryPassword';
  static const String userProfileScreen = '/userProfileScreen';

  // Rutas de Conductor (Cliente SOS)
  static const String sosConductorScreen = '/sos';
  static const String conductorSuscripcionScreen = '/conductorSuscripcion';

  // Rutas de Suscripciones (Administrador TI)
  static const String adminSubscriptionsScreen = '/adminSuscripciones';

  // Rutas de Centro de Mando y Despacho Legal
  static const String legalCenterScreen = '/WeblandingPage';
  static const String edutechScreen = '/WeblandingPage';
  static const String legalCasesScreen = '/legalCases';
  static const String legalLawyersScreen = '/legalLawyers';
  static const String legalCooperativesScreen = '/legalCooperatives';
  static const String legalDocumentsScreen = '/legalDocuments';
  static const String lawyerWorkspaceScreen = '/lawyerWorkspace';

  // Getters para navegación declarativa
  static String getInitialRoute() => initial;
  static String getLoginScreen() => loginScreen;
  static String getRegistrationScreen() => registrationScreen;
  static String getChangeTemporaryPasswordRoute() => changeTemporaryPasswordScreen;
  static String getUserProfileScreen() => userProfileScreen;

  static String getSosConductorRoute() => sosConductorScreen;
  static String getConductorSuscripcionRoute() => conductorSuscripcionScreen;
  static String getSuscripcionConductorRoute() => conductorSuscripcionScreen;
  static String getAdminSubscriptionsRoute() => adminSubscriptionsScreen;

  static String getLegalCenterRoute() => legalCenterScreen;
  static String getEdutechRoute() => legalCenterScreen;
  static String getLegalCasesRoute() => legalCasesScreen;
  static String getLegalLawyersRoute() => legalLawyersScreen;
  static String getLegalCooperativesRoute() => legalCooperativesScreen;
  static String getLegalDocumentsRoute() => legalDocumentsScreen;
  static String getLawyerWorkspaceRoute() => lawyerWorkspaceScreen;

  // Lista de páginas registradas en GetX
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const LoginScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: registrationScreen, page: () => const RegistrationScreen()),
    GetPage(name: changeTemporaryPasswordScreen, page: () => const ChangeTemporaryPasswordScreen()),
    GetPage(name: userProfileScreen, page: () => const UserProfile()),
    GetPage(name: sosConductorScreen, page: () => const DashboardScreen()),
    GetPage(name: conductorSuscripcionScreen, page: () => const SuscripcionConductorScreen()),
    GetPage(name: adminSubscriptionsScreen, page: () => const AdminSubscriptionsScreen()),
    GetPage(name: legalCenterScreen, page: () => const LegalCenterScreen()),
    GetPage(name: legalCasesScreen, page: () => const LegalCasesScreen()),
    GetPage(name: legalLawyersScreen, page: () => const LegalLawyersScreen()),
    GetPage(name: legalCooperativesScreen, page: () => const LegalCooperativesScreen()),
    GetPage(name: legalDocumentsScreen, page: () => const LegalDocumentsScreen()),
    GetPage(name: lawyerWorkspaceScreen, page: () => const LawyerWorkspaceScreen()),
  ];
}
