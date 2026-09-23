import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
      body: SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraMoreLarge,
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                              const FooterSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

