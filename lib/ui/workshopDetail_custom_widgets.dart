import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iit_app/model/appConstants.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/screens/create.dart';
import 'package:iit_app/screens/resource_create.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/dialogBoxes.dart';
import 'package:iit_app/ui/separator.dart';
import 'package:iit_app/ui/text_style.dart';
import 'package:iit_app/ui/workshop_custom_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:skeleton_text/skeleton_text.dart';

class WorkshopDetailCustomWidgets {
  final BuiltWorkshopDetailPost workshopDetail;
  final BuiltWorkshopSummaryPost workshopSummary;
  final BuildContext context;
  final bool isPast;
  final int is_interested;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function() updateButton;
  final Function() reload;
  final Function() deleteWorkshop;
  final Function(int) deleteResource;

  WorkshopDetailCustomWidgets({
    @required this.workshopDetail,
    @required this.workshopSummary,
    @required this.context,
    @required this.isPast,
    @required this.is_interested,
    @required this.scaffoldKey,
    @required this.updateButton,
    @required this.reload,
    @required this.deleteWorkshop,
    @required this.deleteResource,
  });

  Widget _loadingAnimation() {
    return SkeletonAnimation(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: ColorConstants.shimmerSkeletonColor,
        ),
      ),
    );
  }

  final radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  Container getPanel({ScrollController sc}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: ColorConstants.panelColor,
      ),
      padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 10.0),
      child: ListView(
        controller: sc,
        children: [
          getHeading(icon: Icons.location_on, title: 'Location'),
          SizedBox(height: 5.0),
          workshopDetail == null
              ? Container(
                  height: 35.0,
                  child: Center(child: _loadingAnimation()),
                )
              : Text(
                  workshopDetail.location,
                  style: Style.baseTextStyle
                      .copyWith(color: ColorConstants.textColor),
                ),
          SizedBox(height: 5.0),
          workshopDetail?.latitude != null && workshopDetail?.longitude != null
              ? _getLocationOnMaps()
              : Container(),
          SizedBox(height: 15.0),
          getHeading(icon: Icons.library_books, title: 'Resources'),
          SizedBox(height: 5.0),
          workshopDetail == null
              ? Container(
                  height: 35.0,
                  child: Center(child: _loadingAnimation()),
                )
              : (workshopDetail.resources.length == 0)
                  ? Text(
                      "No resources yet",
                      style: Style.baseTextStyle
                          .copyWith(color: ColorConstants.textColor),
                    )
                  : SizedBox(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: workshopDetail.resources.length,
                        itemBuilder: (context, index) {
                          return Row(
                            key: ObjectKey(workshopDetail.resources[index].id),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}. ${workshopDetail.resources[index].name}   (${workshopDetail.resources[index].resource_type})",
                                      style: Style.baseTextStyle.copyWith(
                                          color: ColorConstants.textColor),
                                    ),
                                    SizedBox(height: 5),
                                    InkWell(
                                      splashColor: Colors.yellow,
                                      onTap: () async {
                                        try {
                                          await launch(workshopDetail
                                              .resources[index].link);
                                        } catch (e) {
                                          print(
                                              'error in launching resource link');
                                        }
                                      },
                                      child: Text(
                                        "Link: ${workshopDetail.resources[index].link}",
                                        style: Style.baseTextStyle
                                            .copyWith(color: Colors.blue),
                                      ),
                                    ),
                                    SizedBox(height: 7)
                                  ],
                                ),
                              ),
                              (workshopDetail != null &&
                                      workshopDetail.is_por_holder != null)
                                  ? (workshopDetail.is_por_holder ||
                                          workshopDetail.is_workshop_contact)
                                      ? _editResourceIcons(
                                          workshopDetail.resources[index].id)
                                      : Container()
                                  : Container(),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 2.0);
                        },
                      ),
                    ),

          (workshopDetail != null && workshopDetail.is_por_holder != null)
              ? (workshopDetail.is_por_holder ||
                      workshopDetail.is_workshop_contact)
                  ? RaisedButton(
                      child: Text("Add resources"),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ResourceCreateScreen(workshopDetail),
                          ),
                        ).then((isEdited) {
                          if (isEdited) reload();
                        })
                      },
                    )
                  : Container()
              : Container(),

          //_editResourceIcons(),

          //_workshop.resources,

          SizedBox(height: 15.0),
          getHeading(icon: Icons.people, title: 'Audience'),
          SizedBox(height: 5.0),
          workshopDetail == null
              ? Container(
                  height: 35.0,
                  child: Center(child: _loadingAnimation()),
                )
              : Text(
                  workshopDetail.audience,
                  style: Style.baseTextStyle
                      .copyWith(color: ColorConstants.textColor),
                  //'No Audience',
                ),
          SizedBox(height: 15.0),
          getHeading(icon: Icons.contacts, title: 'Contacts'),
          SizedBox(height: 5.0),
          workshopDetail == null
              ? Container(
                  height: 35.0,
                  child: Center(child: _loadingAnimation()),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.porHolderBackground,
                  ),
                  //color:Colors.grey[300],
                  padding: EdgeInsets.all(15.0),
                  height: 180.0,
                  child: workshopDetail.contacts.length == 0
                      ? Text('No Contacts added...')
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: workshopDetail.contacts.length,
                          itemBuilder: (context, index) {
                            return ClubCouncilAndEntityWidgets.getPosHolder(
                              imageUrl:
                                  workshopDetail.contacts[index].photo_url,
                              name: workshopDetail.contacts[index].name,
                              email: workshopDetail.contacts[index].email,
                              phone:
                                  workshopDetail.contacts[index].phone_number,
                              context: context,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 15.0);
                          },
                        ),
                ),
          SizedBox(height: 15.0),
          getHeading(icon: Icons.bookmark, title: 'Tags'),
          SizedBox(height: 5.0),
          workshopDetail == null
              ? Container(
                  height: 35.0,
                  child: Center(child: _loadingAnimation()),
                )
              : Container(
                  //height: ,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: workshopDetail.tags.length,
                    itemBuilder: (context, index) {
                      return getTag(
                          tag: workshopDetail.tags[index].tag_name,
                          index: index);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _editResourceIcons(int id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.yellow,
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ResourceCreateScreen(workshopDetail, id),
                ),
              ).then((isEdited) {
                if (isEdited == true) reload();
              });
            },
          ),
        ]),
        Column(children: [
          IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              iconSize: 30,
              onPressed: () {
                deleteResource(id);
              })
        ])
      ],
    );
  }

  Widget getPanelBackground() {
    final _editWorkshop = (workshopDetail != null &&
            (workshopDetail.is_por_holder != false ||
                workshopDetail.is_workshop_contact))
        ? editWorkshopOptions()
        : Container();
    final _overviewTitle = "Description".toUpperCase();

    return Container(
      color: ColorConstants.workshopContainerBackground,
      height: MediaQuery.of(context).size.height * 0.90,
      child: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              _getBackground(),
              getGradient(),
              Container(
                padding: EdgeInsets.fromLTRB(0.0,
                    workshopDetail?.image_url != null ? 160 : 72.0, 0.0, 0.0),
                child: WorkshopCustomWidgets.getWorkshopOrEventCard(context,
                    w: workshopSummary, editMode: false, horizontal: false),
              ),
              _editWorkshop,
              getToolbar(context),
            ],
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_overviewTitle, style: Style.headerTextStyle),
                Separator(),
                workshopDetail == null
                    ? _loadingAnimation()
                    : Text(workshopDetail.description,
                        style: Style.commonTextStyle),
                SizedBox(height: 13.0),
                _getPeopleGoing(),
                Separator(),
                SizedBox(
                    height: 2 *
                        ClubCouncilAndEntityWidgets.getMinPanelHeight(context)),
              ],
            ),
          ),
          // SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _getBackground() {
    String imageUrl = workshopDetail?.image_url;
    if (imageUrl?.isEmpty == true) imageUrl = null;

    var _image;
    var _providerImage;
    double height = 295;

    if (imageUrl != null && imageUrl != '') {
      _image = Image.network(imageUrl);
      _providerImage = NetworkImage(imageUrl);
      height = 360;
    } else {
      final isClub = workshopSummary.club != null;
      final id = isClub ? workshopSummary.club.id : workshopSummary.entity.id;

      String logoImageUrl = isClub
          ? workshopSummary.club.small_image_url
          : workshopSummary.entity.small_image_url;

      if (logoImageUrl?.isEmpty == true) logoImageUrl = null;

      final File logoFile =
          logoImageUrl != null ? AppConstants.getImageFile(logoImageUrl) : null;

      if (logoFile == null) {}
      _image = logoFile == null
          ? (logoImageUrl == null || logoImageUrl == ''
              ? Image.asset('assets/iitbhu.jpeg',
                  fit: BoxFit.cover, height: 300.0)
              : Image.network(logoImageUrl, fit: BoxFit.cover, height: 300.0))
          : Image.file(logoFile, fit: BoxFit.cover, height: 300);
      _providerImage = logoFile == null
          ? (logoImageUrl == null || logoImageUrl == ''
              ? AssetImage('assets/iitbhu.jpeg')
              : NetworkImage(logoImageUrl))
          : FileImage(logoFile);
      height = 295;
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => PhotoView(imageProvider: _providerImage),
        ));
      },
      child: Container(
        child: _image,
        constraints: BoxConstraints.expand(height: height),
      ),
    );
  }

  Row _getPeopleGoing() {
    return Row(
      children: <Widget>[
        Text(isPast ? 'Interested by:' : 'People Going:',
            style: TextStyle(
                fontFamily: 'Opensans',
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
        SizedBox(width: 20),
        workshopDetail == null
            ? SkeletonAnimation(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: ColorConstants.shimmerSkeletonColor,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 5.0),
                height: isPast ? 40 : 60.0,
                width: isPast ? 50.0 : 130.0,
                decoration: BoxDecoration(
                    color: ColorConstants.workshopCardContainer,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 7.0),
                    Text(
                      '${workshopDetail.interested_users}',
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    isPast
                        ? Container()
                        : is_interested == 0
                            ? Container(
                                child: _loadingAnimation(),
                                height: 20,
                                width: 20)
                            : InkWell(
                                onTap: () async {
                                  if (AppConstants.isGuest) {
                                    scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Please Log In first'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    if (is_interested != 1) {
                                      bool shouldCalendarBeOpened =
                                          await CreatePageDialogBoxes
                                              .confirmCalendarOpenDialog(
                                                  context: context,
                                                  workshopOrEvent:
                                                      workshopDetail.is_workshop
                                                          ? 'workshop'
                                                          : 'event');
                                      if (shouldCalendarBeOpened == true) {
                                        final String _calendarUrl =
                                            AppConstants.addEventToCalendarLink(
                                                workshop: workshopDetail);
                                        print(
                                            'add workshop/event to calendar URL: $_calendarUrl');
                                        launch(_calendarUrl);
                                      }
                                    }
                                    updateButton();
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.star,
                                        color: is_interested == 1
                                            ? Colors.blue[400]
                                            : Colors.blue[100],
                                        size: 25.0),
                                    Text(
                                      'Interested',
                                      style: TextStyle(
                                        color: is_interested == 1
                                            ? Colors.blue[400]
                                            : Colors.blue[100],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    SizedBox(width: 7.0),
                  ],
                ),
              ),
      ],
    );
  }

  Row _getLocationOnMaps() {
    final mapButton = RaisedButton(
      child: Row(
        children: [Icon(Icons.map), Text("see map")],
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/mapPage', arguments: {
          'fromWorkshopDetails': true,
          'latitude': workshopDetail?.latitude,
          'longitude': workshopDetail?.longitude,
        });
      },
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text('Open In Maps: ',
        //     style: TextStyle(
        //         fontFamily: 'Opensans',
        //         fontSize: 12.0,
        //         color: Colors.white,
        //         fontWeight: FontWeight.w600)),
        SizedBox(width: 10),
        mapButton,
      ],
    );
  }

  Widget editWorkshopOptions() {
    return Positioned(
      right: 10,
      top: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                'Edit',
                style: TextStyle(
                    color: Colors.yellow, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.yellow,
                ),
                iconSize: 50,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEditScreen(
                        club: workshopDetail.club,
                        entity: workshopDetail.entity,
                        title: workshopDetail.club?.name ??
                            workshopDetail.entity?.name ??
                            '',
                        workshopData: workshopDetail,
                        isWorkshopOrEvent:
                            workshopDetail.is_workshop ? 'workshop' : 'event',
                      ),
                    ),
                  ).then((value) {
                    if (value == true) reload();
                  });
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'Delete',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => deleteWorkshop()),
            ],
          )
        ],
      ),
    );
  }

  Column getPanelHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff00c6ff),
            borderRadius: BorderRadius.circular(2.0),
          ),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 2 - 12.0, 10.0, 0.0, 0.0),
          height: 4.0,
          width: 24.0,
        ),
      ],
    );
  }

  Row getHeading({IconData icon, String title}) {
    Color color = ColorConstants.headingColor;
    TextStyle headingStyle = TextStyle(
        fontSize: 22.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        color: color);
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 5.0),
        Text(
          title,
          style: headingStyle,
        ),
      ],
    );
  }

  Container getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            ColorConstants.workshopContainerBackground.withAlpha(0),
            ColorConstants.workshopContainerBackground
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container getToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BackButton(color: Colors.lightGreen),
    );
  }

  Padding getTag({String tag, int index}) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.grey,
    ];
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              tag,
            ),
          ),
        ],
      ),
    );
  }
}
