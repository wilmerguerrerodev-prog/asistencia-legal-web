import 'package:flutter/material.dart';
import 'package:getdash/core/auth/model/mock_user.dart';
import 'package:getdash/core/helper/route_helper.dart';

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

/// Menú global para Administrador TI con acceso a todos los módulos legales
List<MenuModel> menuList = [
  MenuModel(
    iconData: Icons.local_taxi_rounded,
    menuTitle: 'LegalTech Cliente',
    route: RouteHelper.getSosConductorRoute(),
  ),
  MenuModel(
    iconData: Icons.badge_rounded,
    menuTitle: 'Mi Perfil',
    route: RouteHelper.getUserProfileScreen(),
  ),
  MenuModel(
    iconData: Icons.card_membership_rounded,
    menuTitle: 'Mi Suscripción',
    route: RouteHelper.getConductorSuscripcionRoute(),
  ),
  MenuModel(
    iconData: Icons.shield_rounded,
    menuTitle: 'Centro de Mando Legal',
    route: RouteHelper.getLegalCenterRoute(),
  ),
  MenuModel(
    iconData: Icons.gavel_rounded,
    menuTitle: 'Mi Despacho (Abogado)',
    route: RouteHelper.getLawyerWorkspaceRoute(),
  ),
  MenuModel(
    iconData: Icons.policy_rounded,
    menuTitle: 'asistencia_juridica',
    subMenus: [
      SubMenu(
        subMenuTitle: 'casos_siniestros',
        route: RouteHelper.getLegalCasesRoute(),
      ),
      SubMenu(
        subMenuTitle: 'abogados_territorio',
        route: RouteHelper.getLegalLawyersRoute(),
      ),
      SubMenu(
        subMenuTitle: 'cooperativas_flotas',
        route: RouteHelper.getLegalCooperativesRoute(),
      ),
      SubMenu(
        subMenuTitle: 'dictamenes_actas',
        route: RouteHelper.getLegalDocumentsRoute(),
      ),
    ],
  ),
];

/// Menú filtrado por roles estrictos de la plataforma
List<MenuModel> getMenuListForRole(UserRole role) {
  switch (role) {
    case UserRole.itAdmin:
      return menuList; // Acceso total para SuperAdmin TI

    case UserRole.adminLawyer:
      return [
        MenuModel(
          iconData: Icons.shield_rounded,
          menuTitle: 'Centro de Mando',
          route: RouteHelper.getLegalCenterRoute(),
        ),
        MenuModel(
          iconData: Icons.badge_rounded,
          menuTitle: 'Mi Perfil',
          route: RouteHelper.getUserProfileScreen(),
        ),
        MenuModel(
          iconData: Icons.gavel_rounded,
          menuTitle: 'asistencia_juridica',
          subMenus: [
            SubMenu(
              subMenuTitle: 'casos_siniestros',
              route: RouteHelper.getLegalCasesRoute(),
            ),
            SubMenu(
              subMenuTitle: 'abogados_territorio',
              route: RouteHelper.getLegalLawyersRoute(),
            ),
            SubMenu(
              subMenuTitle: 'cooperativas_flotas',
              route: RouteHelper.getLegalCooperativesRoute(),
            ),
            SubMenu(
              subMenuTitle: 'dictamenes_actas',
              route: RouteHelper.getLegalDocumentsRoute(),
            ),
          ],
        ),
      ];

    case UserRole.associateLawyer:
      return [
        MenuModel(
          iconData: Icons.shield_rounded,
          menuTitle: 'Mi Despacho',
          route: RouteHelper.getLawyerWorkspaceRoute(),
        ),
        MenuModel(
          iconData: Icons.description_rounded,
          menuTitle: 'Dictámenes & Actas',
          route: RouteHelper.getLegalDocumentsRoute(),
        ),
        MenuModel(
          iconData: Icons.badge_rounded,
          menuTitle: 'Mi Perfil',
          route: RouteHelper.getUserProfileScreen(),
        ),
      ];

    case UserRole.clientDriver:
      return [
        MenuModel(
          iconData: Icons.local_taxi_rounded,
          menuTitle: 'Portal Conductor SOS',
          route: RouteHelper.getSosConductorRoute(),
        ),
        MenuModel(
          iconData: Icons.badge_rounded,
          menuTitle: 'Mi Perfil',
          route: RouteHelper.getUserProfileScreen(),
        ),
        MenuModel(
          iconData: Icons.card_membership_rounded,
          menuTitle: 'Mi Suscripción',
          route: RouteHelper.getConductorSuscripcionRoute(),
        ),
      ];
  }
}
