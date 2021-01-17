import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/pages/club_entity/clubPage.dart';
import 'package:iit_app/pages/club_entity/entityPage.dart';
import 'package:iit_app/pages/login/loginPage.dart';
import 'package:iit_app/services/pushNotification.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:iit_app/pages/worshop_detail/workshopDetailPage.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
    _initLink();
    _initFCM();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    await _handleDeepLink(data);

    // Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // handle link that has been retrieved
      await _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      int id = int.tryParse(deepLink.queryParameters['id']);
      if (deepLink.queryParameters['isPast'] != null) {
        bool isPast = deepLink.queryParameters['isPast'] == 'true';

        await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => WorkshopDetailPage(
              id,
              workshop: null,
              isPast: isPast,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        );
      } else {
        deepLink.queryParameters['isClub'] == 'true'
            ? Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => ClubPage(clubId: id),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              ))
            : Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => EntityPage(entityId: id),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              ));
      }
    }
  }

  _initFCM() {
    Future.delayed(
      Duration(milliseconds: 300),
      () async {
        final Map arguments = ModalRoute.of(context).settings.arguments as Map;
        // to ensure that this function is not called unnecessarily.
        if (arguments['initFCM'] == true)
          await PushNotification.initialize(context);
      },
    );
  }

  _initLink() {
    Future.delayed(
      Duration(milliseconds: 300),
      () async {
        final Map arguments = ModalRoute.of(context).settings.arguments as Map;
        // to ensure that this function is not called unnecessarily.
        if (arguments['initLink'] == true) await initDynamicLinks();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (AppConstants.isLoggedIn || AppConstants.isGuest)
        ? HomePage()
        : LoginPage();
  }
}
