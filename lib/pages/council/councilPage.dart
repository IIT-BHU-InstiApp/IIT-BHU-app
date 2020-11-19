import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/ui/council_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iit_app/pages/account/accountPage.dart';

class CouncilPage extends StatefulWidget {
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  BuiltCouncilPost councilData;
  File _councilLargeLogoFile;

  flag() {
    AccountPage.flag = "Council";
  }

  @override
  void initState() {
    flag();
    fetchCouncilById();
    super.initState();
  }

  void fetchCouncilById() async {
    print('fetching council data ');
    councilData =
        await AppConstants.getCouncilDetailsFromDatabase(councilId: AppConstants.currentCouncilId);

    _councilLargeLogoFile =
        AppConstants.getImageFile(isCouncil: true, isSmall: false, id: councilData.id);

    if (_councilLargeLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(
          isCouncil: true, isSmall: false, id: councilData.id, url: councilData.large_image_url);
    }

    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  PanelController _pc = PanelController();

  @override
  Widget build(BuildContext context) {
    final councilCustomWidgets = CouncilCustomWidgets(context: context, councilData: councilData);
    return SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          backgroundColor: ColorConstants.backgroundThemeColor,
          body: RefreshIndicator(
            onRefresh: () async {
              if (councilData != null) {
                councilData =
                    await AppConstants.refreshCouncilInDatabase(councilId: councilData.id);
              }
              setState(() {});
            },
            child: SlidingUpPanel(
              parallaxEnabled: true,
              body: ClubAndCouncilWidgets.getPanelBackground(context, _councilLargeLogoFile,
                  isCouncil: true, councilDetail: councilData),
              controller: _pc,
              borderRadius: radius,
              collapsed: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                ),
              ),
              backdropEnabled: true,
              panelBuilder: (ScrollController sc) =>
                  councilCustomWidgets.getPanel(scrollController: sc, radius: radius),
              minHeight: ClubAndCouncilWidgets.getMinPanelHeight(context),
              maxHeight: ClubAndCouncilWidgets.getMaxPanelHeight(context),
              header: ClubAndCouncilWidgets.getHeader(context),
            ),
          ),
        ));
  }
}
