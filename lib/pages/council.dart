import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/club_council_common/club_&_council_widgets.dart';
import 'package:iit_app/pages/club_council_common/description.dart';
import 'package:iit_app/ui/colorPicker.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:iit_app/screens/account.dart';

class CouncilPage extends StatefulWidget {
  @override
  _CouncilPageState createState() => _CouncilPageState();
}

class _CouncilPageState extends State<CouncilPage> {
  BuiltCouncilPost councilData;
  File _councilLargeLogoFile;

  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

  bool _mainBg = false,
      _cardBg = false,
      _bodyBg = false,
      _panelBg = false,
      _porBg = false;

  flag() {
    AccountScreen.flag = "Council";
  }

  setColorPalleteOff() {
    _mainBg = false;
    _cardBg = false;
    _bodyBg = false;
    _panelBg = false;
    _porBg = false;
  }

  Widget _colorSelectOptionRow(context) {
    return Container(
      height: 45,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _mainBg = true;
                _colorListener.value = ColorConstants.backgroundThemeColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('main bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _cardBg = true;
                _colorListener.value = ColorConstants.workshopCardContainer;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('card bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _bodyBg = true;
                _colorListener.value =
                    ColorConstants.workshopContainerBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('body bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _panelBg = true;
                _colorListener.value = ColorConstants.panelColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('panel bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _porBg = true;
                _colorListener.value = ColorConstants.porHolderBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('por bg'),
            ),
          ),
          Container(
            color: Colors.red[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                AppConstants.chooseColorPaletEnabled = false;
                _colorListener.value = Colors.white;
              },
              child: Text('Clear  X'),
            ),
          ),
        ],
      ),
    );
  }

  setColor() {
    if (_mainBg) {
      ColorConstants.backgroundThemeColor = _colorListener.value;
    } else if (_cardBg) {
      ColorConstants.workshopCardContainer = _colorListener.value;
    } else if (_bodyBg) {
      ColorConstants.workshopContainerBackground = _colorListener.value;
    } else if (_panelBg) {
      ColorConstants.panelColor = _colorListener.value;
    } else if (_porBg) {
      ColorConstants.porHolderBackground = _colorListener.value;
    }
  }

  @override
  void initState() {
    this._colorListener = ValueNotifier(Colors.white);
    this._colorPicker = ColorPicker(this._colorListener);
    flag();
    fetchCouncilById();
    super.initState();
  }

  void fetchCouncilById() async {
    print('fetching council data ');
    councilData = await AppConstants.getCouncilDetailsFromDatabase(
        councilId: AppConstants.currentCouncilId);

    _councilLargeLogoFile = AppConstants.getImageFile(
        isCouncil: true, isSmall: false, id: councilData.id);

    if (_councilLargeLogoFile == null) {
      AppConstants.writeImageFileIntoDisk(
          isCouncil: true,
          isSmall: false,
          id: councilData.id,
          url: councilData.large_image_url);
    }

    if (!this.mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  final space = SizedBox(height: 8.0);

  final divide = Divider(height: 8.0, thickness: 2.0, color: Colors.blue);

  Widget _getBackground(context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: ColorConstants.workshopContainerBackground,
      height: MediaQuery.of(context).size.height * 0.90,
      child: councilData == null
          ? Container(
              height: MediaQuery.of(context).size.height * 3 / 4,
              child: Center(
                child: LoadingCircle,
              ),
            )
          : ListView(
              //physics: BouncingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Container(
                      child: _councilLargeLogoFile == null
                          ? Image.network(councilData.large_image_url,
                              fit: BoxFit.cover, height: 300.0)
                          : Image.file(_councilLargeLogoFile,
                              fit: BoxFit.cover, height: 300.0),
                      constraints: BoxConstraints.expand(height: 295.0),
                    ),
                    ClubAndCouncilWidgets.getGradient(),
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 0.0),
                      child: ClubAndCouncilWidgets.getClubCard(
                          title: councilData.name,
                          id: councilData.id,
                          imageUrl: councilData.large_image_url,
                          isCouncil: true,
                          context: context),
                    ),
                    ClubAndCouncilWidgets.getToolbar(context),
                  ],
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Description(map: councilData, isCouncil: true),
                ),
                SizedBox(height: 15.0),
                ClubAndCouncilWidgets.getSecies(context,
                    secy: councilData.gensec,
                    joint_secy: councilData.joint_gensec),
                //SizedBox(height: 15.0),
                councilData == null
                    ? Container()
                    : ClubAndCouncilWidgets.getSocialLinks(councilData),
                SizedBox(
                    height:
                        1.5 * ClubAndCouncilWidgets.getMinPanelHeight(context)),
              ],
            ),
    );
  }

  Widget _getClubs() {
    return councilData == null
        ? Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: LoadingCircle,
            ),
          )
        : Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: councilData.clubs.length,
              itemBuilder: (context, index) {
                return ClubAndCouncilWidgets.getClubCard(
                  context: context,
                  title: councilData.clubs[index].name,
                  subtitle: councilData.name,
                  id: councilData.clubs[index].id,
                  imageUrl: councilData.clubs[index].small_image_url,
                  isCouncil: false,
                  club: councilData.clubs[index],
                  horizontal: true,
                );
              },
            ),
          );
  }

  Widget _getPanel({ScrollController sc}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      padding: EdgeInsets.only(top: 20.0),
      child: ListView(
        controller: sc,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //scrollDirection: Axis.vertical,
        children: <Widget>[
          space,
          Container(
            //margin: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Clubs',
                          style: Style.headingStyle, textAlign: TextAlign.left),
                      divide,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _getClubs(),
        ],
      ),
    );
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  PanelController _pc = PanelController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: ValueListenableBuilder(
          valueListenable: _colorListener,
          builder: (context, color, child) {
            setColor();

            return Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              backgroundColor: ColorConstants.backgroundThemeColor,
              body: RefreshIndicator(
                onRefresh: () async {
                  if (councilData != null) {
                    councilData = await AppConstants.refreshCouncilInDatabase(
                        councilId: councilData.id);
                  }
                  setState(() {});
                },
                child: Stack(
                  children: [
                    SlidingUpPanel(
                      parallaxEnabled: true,
                      body: _getBackground(context),
                      controller: _pc,
                      borderRadius: radius,
                      collapsed: Container(
                        decoration: BoxDecoration(
                          borderRadius: radius,
                        ),
                      ),
                      backdropEnabled: true,
                      panelBuilder: (ScrollController sc) => _getPanel(sc: sc),
                      /*panel: Dismissible(
                      key: Key('clubs'),
                      direction: DismissDirection.down,
                      onDismissed: (_) => _pc.close(),
                      child: _getPanel(),
                    ),*/
                      minHeight:
                          ClubAndCouncilWidgets.getMinPanelHeight(context),
                      maxHeight:
                          ClubAndCouncilWidgets.getMaxPanelHeight(context),
                      header: ClubAndCouncilWidgets.getHeader(context),
                    ),
                    AppConstants.chooseColorPaletEnabled
                        ? _colorSelectOptionRow(context)
                        : Container()
                  ],
                ),
              ),
            );
          }),
    );
  }
}
