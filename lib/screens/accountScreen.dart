import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/ui/club_council_entity_common/club_council_entity_widgets.dart';
import 'package:iit_app/ui/text_style.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    Key key,
    @required this.profileDetails,
    @required this.asyncInputDialog,
    @required this.updateProfileDetails,
  }) : super(key: key);

  final BuiltProfilePost profileDetails;
  final Function(BuildContext, String, String) asyncInputDialog;
  final Function(String, String) updateProfileDetails;

  Widget subscribed(String v) {
    if (v == 'Club') {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profileDetails.club_subscriptions.length,
        itemBuilder: (context, index) {
          return ClubCouncilAndEntityWidgets.getTitleCard(
            clubTypeForHero: 'club_subscriptions',
            isClub: true,
            context: context,
            title: profileDetails.club_subscriptions[index].name,
            subtitle: profileDetails.club_subscriptions[index].council.name,
            id: profileDetails.club_subscriptions[index].id,
            imageUrl: profileDetails.club_subscriptions[index].small_image_url,
            club: profileDetails.club_subscriptions[index],
            horizontal: true,
          );
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profileDetails.entity_subscriptions.length,
        itemBuilder: (context, index) {
          return ClubCouncilAndEntityWidgets.getTitleCard(
              entityTypeForHero: 'entity_subscriptions',
              context: context,
              title: profileDetails.entity_subscriptions[index].name,
              id: profileDetails.entity_subscriptions[index].id,
              imageUrl:
                  profileDetails.entity_subscriptions[index].small_image_url,
              entity: profileDetails.entity_subscriptions[index],
              isEntity: true,
              horizontal: true);
        },
      );
    }
  }

  Container iconTile({String imgAssetPath, Color backColor}) => Container(
        margin: EdgeInsets.only(right: 16),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: backColor, borderRadius: BorderRadius.circular(15)),
          child: Image.asset(
            imgAssetPath,
            width: 20,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.homeBackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.homeBackground,
        title: Text(
          "Your Account",
          style: Style.baseTextStyle.copyWith(color: ColorConstants.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: SideBar(context: context),
      body: SingleChildScrollView(
        child: profileDetails == null
            ? Container(
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: LoadingCircle,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Center(
                            child: CircleAvatar(
                          backgroundImage: profileDetails.photo_url == null ||
                                  profileDetails.photo_url == ''
                              ? AssetImage('assets/AMC.png')
                              : NetworkImage(profileDetails.photo_url),
                          radius: 30.0,
                          backgroundColor: Colors.transparent,
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    child: Text(
                                      profileDetails.name,
                                      style: Style.headerTextStyle.copyWith(
                                          fontSize: 25,
                                          color: ColorConstants.textColor),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      final name = await asyncInputDialog(
                                          context, 'Name', profileDetails.name);
                                      print(name);
                                      updateProfileDetails(
                                          name, profileDetails.phone_number);
                                    },
                                  )
                                ],
                              ),
                              Text(profileDetails.department,
                                  style: Style.commonTextStyle.copyWith(
                                      color: ColorConstants.textColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        iconTile(
                          backColor: Color(0xffFFECDD),
                          imgAssetPath: "assets/email.png",
                        ),
                        Expanded(
                          child: Text(
                            profileDetails.email,
                            style: Style.baseTextStyle
                                .copyWith(color: ColorConstants.textColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        iconTile(
                          backColor: Color(0xffFFECDD),
                          imgAssetPath: "assets/call.png",
                        ),
                        Text(
                          profileDetails.phone_number == null
                              ? 'not provided'
                              : profileDetails.phone_number,
                          style: Style.baseTextStyle
                              .copyWith(color: ColorConstants.textColor),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final phoneNumber = await asyncInputDialog(
                                context,
                                'Phone No.',
                                profileDetails.phone_number == ''
                                    ? '+91'
                                    : profileDetails.phone_number);
                            print(phoneNumber);
                            updateProfileDetails(
                                profileDetails.name, phoneNumber);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Club Subscriptions",
                      style: Style.boldHeadingStyle
                          .copyWith(color: ColorConstants.textColor),
                    ),
                    SizedBox(height: 5),
                    profileDetails == null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Center(
                              child: LoadingCircle,
                            ),
                          )
                        : profileDetails.club_subscriptions.length == 0
                            ? Text(
                                'You haven\'t subscribed to any channels yet!',
                                style:
                                    TextStyle(color: ColorConstants.textColor),
                              )
                            : Container(child: subscribed("Club")),
                    SizedBox(height: 22),
                    Text(
                      "Entity Subscriptions",
                      style: Style.boldHeadingStyle
                          .copyWith(color: ColorConstants.textColor),
                    ),
                    SizedBox(height: 5),
                    profileDetails == null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Center(
                              child: LoadingCircle,
                            ),
                          )
                        : profileDetails.entity_subscriptions.length == 0
                            ? Text(
                                'You haven\'t subscribed to any entities yet!',
                                style:
                                    TextStyle(color: ColorConstants.textColor),
                              )
                            : Container(child: subscribed("Entity")),
                    profileDetails.club_privileges.length == 0
                        ? Container()
                        : SizedBox(height: 22),
                    profileDetails.club_privileges.length == 0
                        ? SizedBox(height: 5)
                        : Text(
                            "Club Privileges",
                            style: Style.boldHeadingStyle
                                .copyWith(color: ColorConstants.textColor),
                          ),
                    profileDetails.club_privileges.length == 0
                        ? Container()
                        : SizedBox(height: 5),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileDetails.club_privileges.length,
                        itemBuilder: (context, index) {
                          return ClubCouncilAndEntityWidgets.getTitleCard(
                              clubTypeForHero: 'Club Privileges',
                              context: context,
                              title: profileDetails.club_privileges[index].name,
                              subtitle: profileDetails
                                  .club_privileges[index].council.name,
                              id: profileDetails.club_privileges[index].id,
                              imageUrl: profileDetails
                                  .club_privileges[index].small_image_url,
                              club: profileDetails.club_privileges[index],
                              isClub: true,
                              horizontal: true);
                        },
                      ),
                    ),
                    SizedBox(height: 22),
                    profileDetails.entity_privileges.length == 0
                        ? SizedBox(height: 5)
                        : Text(
                            "Entity Privileges",
                            style: Style.boldHeadingStyle
                                .copyWith(color: ColorConstants.textColor),
                          ),
                    SizedBox(height: 5),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileDetails.entity_privileges.length,
                        itemBuilder: (context, index) {
                          return ClubCouncilAndEntityWidgets.getTitleCard(
                              entityTypeForHero: 'Entity Privileges',
                              context: context,
                              title:
                                  profileDetails.entity_privileges[index].name,
                              id: profileDetails.entity_privileges[index].id,
                              imageUrl: profileDetails
                                  .entity_privileges[index].small_image_url,
                              entity: profileDetails.entity_privileges[index],
                              isEntity: true,
                              horizontal: true);
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }
}
