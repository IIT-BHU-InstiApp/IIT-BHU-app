import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/ui/text_style.dart';
import '../services/buildWorkshops.dart' as buildWorkhops;
import 'package:iit_app/data/internet_connection_interceptor.dart';

class InterestedScreen extends StatefulWidget {
  @override
  _InterestedScreenState createState() => _InterestedScreenState();
}

class _InterestedScreenState extends State<InterestedScreen>
    with SingleTickerProviderStateMixin {
  void reload() async {
    try {
      await AppConstants.service
          .getInterestedWorkshops(AppConstants.djangoToken);
      setState(() {});
    } on InternetConnectionException catch (_) {
      AppConstants.internetErrorFlushBar.showFlushbar(context);
      return;
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
          backgroundColor: ColorConstants.homeBackground,
          drawer: SideBar(context: context),
          appBar: AppBar(
            title: Text(
              "Your Interests:",
              style: Style.baseTextStyle.copyWith(color: Colors.white),
            ),
            backgroundColor: ColorConstants.homeBackground,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black87),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage())),
            ),
          ),
          body: Container(
            child: AppConstants.isGuest
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'We value your interest, but first you have to trust us by logging in.   {Dear Guest, it can not be one sided.}',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                : RefreshIndicator(
                    displacement: 60,
                    onRefresh: () async => reload(),
                    child: buildWorkhops.buildInterestedWorkshopsBody(
                      context,
                      reload: reload,
                    ),
                  ),
          )),
    );
  }
}
