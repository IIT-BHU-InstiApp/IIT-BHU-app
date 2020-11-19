import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/spin_kit.dart';
import 'package:iit_app/model/built_post.dart';
import 'package:iit_app/model/colorConstants.dart';
import 'package:iit_app/pages/Home/homePage.dart';
import 'package:iit_app/pages/account/accountPage.dart';
import 'package:iit_app/ui/drawer.dart';
import 'package:iit_app/ui/club_council_common/club_&_council_widgets.dart';

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
    print("Subscribed: $v");
    print("Flag:${AccountPage.flag}");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profileDetails.subscriptions.length,
      itemBuilder: (context, index) {
        return ClubAndCouncilWidgets.getTitleCard(
            clubTypeForHero: 'Subscriptions',
            context: context,
            title: profileDetails.subscriptions[index].name,
            subtitle: profileDetails.subscriptions[index].council.name,
            id: profileDetails.subscriptions[index].id,
            imageUrl: profileDetails.subscriptions[index].small_image_url,
            club: profileDetails.subscriptions[index],
            isCouncil: false,
            horizontal: true);
      },
    );
  }

  Container iconTile({String imgAssetPath, Color backColor}) => Container(
        margin: EdgeInsets.only(right: 16),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(15)),
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
        elevation: 0.0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
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
                    Row(
                      children: <Widget>[
                        Center(
                            child: CircleAvatar(
                          backgroundImage: profileDetails.photo_url == null
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
                                    width: MediaQuery.of(context).size.width - 200,
                                    child: Text(
                                      profileDetails.name,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      final name = await asyncInputDialog(
                                          context, 'Name', profileDetails.name);
                                      print(name);
                                      updateProfileDetails(name, profileDetails.phone_number);
                                    },
                                  )
                                ],
                              ),
                              Text(
                                profileDetails.department,
                                style: TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        iconTile(
                          backColor: Color(0xffFFECDD),
                          imgAssetPath: "assets/email.png",
                        ),
                        Expanded(
                          child: Text(
                            profileDetails.email,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                          style: TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final phoneNumber = await asyncInputDialog(
                                context, 'Phone No.', profileDetails.phone_number);
                            print(phoneNumber);
                            updateProfileDetails(profileDetails.name, phoneNumber);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Subscriptions",
                      style: TextStyle(
                          color: Color(0xff242424), fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    profileDetails == null
                        ? Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Center(
                              child: LoadingCircle,
                            ),
                          )
                        : profileDetails.subscriptions.length == 0
                            ? Text('You haven\'t subscribed to any channels yet!')
                            : Container(child: subscribed("Club")),
                    SizedBox(
                      height: 22,
                    ),
                    profileDetails.club_privileges.length == 0
                        ? SizedBox(height: 5)
                        : Text(
                            "Club Privileges",
                            style: TextStyle(
                                color: Color(0xff242424),
                                fontSize: 28,
                                fontWeight: FontWeight.w600),
                          ),
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileDetails.club_privileges.length,
                        itemBuilder: (context, index) {
                          return ClubAndCouncilWidgets.getTitleCard(
                              clubTypeForHero: 'Club Privileges',
                              context: context,
                              title: profileDetails.club_privileges[index].name,
                              subtitle: profileDetails.club_privileges[index].council.name,
                              id: profileDetails.club_privileges[index].id,
                              imageUrl: profileDetails.club_privileges[index].small_image_url,
                              club: profileDetails.club_privileges[index],
                              isCouncil: false,
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
