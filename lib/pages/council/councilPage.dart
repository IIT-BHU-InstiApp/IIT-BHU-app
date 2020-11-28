import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/council_custom_widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CouncilPage extends StatefulWidget {
  final int councilId;
  const CouncilPage(this.councilId);
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  BuiltCouncilPost councilData;
  File _councilLargeLogoFile;

  @override
  void initState() {
    _fetchCouncilById();
    super.initState();
  }

  void _reload() {
    _fetchCouncilById(refresh: true);
  }

  void _fetchCouncilById({bool refresh = false}) async {
    print('fetching council data ');
    councilData = await AppConstants.getCouncilDetailsFromDatabase(
        councilId: widget.councilId, refresh: refresh);

    _councilLargeLogoFile =
        AppConstants.getImageFile(councilData.large_image_url);

    if (_councilLargeLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(councilData.large_image_url);
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

  Future<bool> _willPopCallback() async {
    if (_pc.isPanelOpen) {
      _pc.close();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final councilCustomWidgets =
        CouncilCustomWidgets(context: context, councilData: councilData);
    return SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: WillPopScope(
          onWillPop: _willPopCallback,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            resizeToAvoidBottomPadding: false,
            backgroundColor: ColorConstants.backgroundThemeColor,
            body: RefreshIndicator(
              onRefresh: () async => _reload(),
              child: SlidingUpPanel(
                parallaxEnabled: true,
                body: ClubCouncilAndEntityWidgets.getPanelBackground(
                    context, _councilLargeLogoFile,
                    isCouncil: true, councilDetail: councilData),
                controller: _pc,
                borderRadius: radius,
                collapsed: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                  ),
                ),
                backdropEnabled: true,
                panelBuilder: (ScrollController sc) => councilCustomWidgets
                    .getPanel(scrollController: sc, radius: radius),
                minHeight:
                    ClubCouncilAndEntityWidgets.getMinPanelHeight(context),
                maxHeight:
                    ClubCouncilAndEntityWidgets.getMaxPanelHeight(context),
                header: ClubCouncilAndEntityWidgets.getHeader(context),
              ),
            ),
          ),
        ));
  }
}
