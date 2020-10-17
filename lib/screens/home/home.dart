import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/home/app_bar.dart';
import 'package:iit_app/screens/home/floating_action_button.dart';
import 'package:iit_app/screens/home/home_widgets.dart';
import 'package:iit_app/screens/home/search_workshop.dart';
import 'package:iit_app/screens/drawer.dart';
import 'package:iit_app/ui/colorPicker.dart';
import 'package:iit_app/ui/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/sharedPreferenceKeys.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  SearchBarWidget searchBarWidget;
  ValueNotifier<bool> searchListener;
  ValueNotifier<Color> _colorListener;
  ColorPicker _colorPicker;

  FocusNode searchFocusNode;

  bool _mainBg = false,
      _ringBg = false,
      _shimmerBg = false,
      _workshopContainerBg = false,
      _cardBg = false;

  final GlobalKey<FabCircularMenuState> fabKey =
      GlobalKey<FabCircularMenuState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    fetchWorkshopsAndCouncilButtons();
    _setTheme();
    searchListener = ValueNotifier(false);
    searchBarWidget = SearchBarWidget(searchListener);

    this._colorListener = ValueNotifier(Colors.white);
    this._colorPicker = ColorPicker(this._colorListener);

    searchFocusNode = FocusNode();
    super.initState();
  }

  _setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs.getString(SharedPreferenceKeys.usertheme));
    if (prefs.getString(SharedPreferenceKeys.usertheme) == 'dark') {
      AppTheme().dark();
    } else {
      AppTheme().light();
    }
  }

  fetchWorkshopsAndCouncilButtons() async {
    await AppConstants.populateWorkshopsAndCouncilButtons();
    setState(() {
      AppConstants.firstTimeFetching = false;
    });
    fetchUpdatedDetails();
  }

  void fetchUpdatedDetails() async {
    await AppConstants.updateAndPopulateWorkshops();
    await AppConstants.writeCouncilLogosIntoDisk(
        AppConstants.councilsSummaryfromDatabase);
    setState(() {});
  }

  Future<bool> _onPopHome() async {
    if (fabKey.currentState.isOpen) {
      print('fab is open');
      fabKey.currentState.close();
      return false;
    }
    if (_scaffoldKey.currentState.isDrawerOpen) {
      print('drawer is open');
      Navigator.of(context).pop();

      return false;
    }
    // if on home screen but searchController is onFocus
    if (!searchBarWidget.isSearching.value && searchFocusNode.hasFocus) {
      searchBarWidget.searchController.clear();
      searchFocusNode.unfocus();
      return false;
    }
    // to retrun on home route on popping from search result screen
    if (searchBarWidget.isSearching.value) {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
      return false;
    }
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text('Do you really want to exit?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  setColorPalleteOff() {
    _mainBg = false;
    _ringBg = false;
    _shimmerBg = false;
    _workshopContainerBg = false;
    _cardBg = false;
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
                _colorListener.value = ColorConstants.homeBackground;
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
                _ringBg = true;
                _colorListener.value = ColorConstants.circularRingBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('ring bg'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _shimmerBg = true;
                _colorListener.value = ColorConstants.shimmerSkeletonColor;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('shimmer'),
            ),
          ),
          Container(
            color: Colors.blue[100],
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {
                setColorPalleteOff();
                _workshopContainerBg = true;
                _colorListener.value =
                    ColorConstants.workshopContainerBackground;
                return _colorPicker.getColorPickerDialogBox(context);
              },
              child: Text('container'),
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
              child: Text('card'),
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
      ColorConstants.homeBackground = _colorListener.value;
    } else if (_ringBg) {
      ColorConstants.circularRingBackground = _colorListener.value;
    } else if (_shimmerBg) {
      ColorConstants.shimmerSkeletonColor = _colorListener.value;
    } else if (_workshopContainerBg) {
      ColorConstants.workshopContainerBackground = _colorListener.value;
    } else if (_cardBg) {
      ColorConstants.workshopCardContainer = _colorListener.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPopHome,
      child: SafeArea(
        minimum: const EdgeInsets.all(2.0),
        child: ValueListenableBuilder(
          valueListenable: _colorListener,
          builder: (context, color, child) {
            setColor();
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: ColorConstants.homeBackground,
              drawer: SideBar(context: context),
              floatingActionButton: homeFAB(context, fabKey: fabKey),
              appBar: homeAppBar(context,
                  searchBarWidget: searchBarWidget,
                  fabKey: fabKey,
                  searchFocusNode: searchFocusNode),
              body: GestureDetector(
                onTap: () {
                  if (fabKey.currentState.isOpen) {
                    fabKey.currentState.close();
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
                      decoration: BoxDecoration(
                          color: ColorConstants.workshopContainerBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0))),
                      child: ValueListenableBuilder(
                        valueListenable: searchListener,
                        builder: (context, isSearching, child) {
                          return HomeChild(
                            context: context,
                            searchBarWidget: searchBarWidget,
                            tabController: _tabController,
                            isSearching: isSearching,
                            fabKey: fabKey,
                          );
                        },
                      ),
                    ),
                    AppConstants.chooseColorPaletEnabled
                        ? _colorSelectOptionRow(context)
                        : Container()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
