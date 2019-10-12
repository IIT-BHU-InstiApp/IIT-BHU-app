import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/screens/account.dart';
import 'package:iit_app/screens/settings.dart';
import 'package:iit_app/screens/create.dart';
import 'package:iit_app/data/workshop.dart';
import 'package:iit_app/pages/detail.dart';
import 'package:iit_app/pages/login.dart';
import 'package:iit_app/services/crud.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CrudMethods crudObj = new CrudMethods();
  Stream workshops;

  Drawer getNavDrawer(BuildContext context) {
    ListTile getNavItem(var icon, String s, String routeName,
        {bool replacement = false}) {
      return ListTile(
        leading: Icon(icon),
        title: Text(s),
        onTap: () {
          // pop closes the drawer
          Navigator.of(context).pop();
          // navigate to the route
          if (replacement)
            Navigator.of(context).pushReplacementNamed(routeName);
          else
            Navigator.of(context).pushNamed(routeName);
        },
      );
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: Text("Header")),
          getNavItem(Icons.plus_one, "Create Workshop", CreateScreen.routeName),
          getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
          getNavItem(Icons.home, "Home", HomeScreen.routeName,
              replacement: true),
          getNavItem(Icons.account_box, "Account", AccountScreen.routeName),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Out'),
            onTap: () {
              Navigator.of(context).pop();
              signOutGoogle();
              Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
            },
          ),
          AboutListTile(
              child: Text("About"),
              applicationName: "Gymkhana IIT(BHU)",
              applicationVersion: "v1.0.0",
              applicationIcon: Icon(Icons.business),
              aboutBoxChildren: <Widget>[
                Text('Front End'),
                InkWell(
                  child: new Text('@nishantkr18'),
                  onTap: () => launch('https://github.com/nishantkr18'),
                ),
                Text('Back End:'),
                InkWell(
                  child: new Text('@nishantwrp'),
                  onTap: () => launch('https://github.com/nishantwrp'),
                ),
                InkWell(
                  child: new Text('@krashish8'),
                  onTap: () => launch('https://github.com/krashish8'),
                ),
              ],
              icon: Icon(Icons.info)),
        ],
      ),
    );
  }

  _buildCard({Workshop w}) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => DetailPage(w)));
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: 275.0,
                width: 200.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: AssetImage(Workshop.imgPath[w.club]),
                        fit: BoxFit.cover)),
              ),
              // make the shade a bit deeper.
              Container(
                height: 275.0,
                width: 200.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.5)),
              ),
              Positioned(
                  top: 20.0,
                  left: 10.0,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 25,
                            // width: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              // color: Colors.black.withOpacity(0.5)
                            ),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.date_range,
                                    color: Colors.white, size: 12.0),
                                SizedBox(width: 4.0),
                                Text(
                                  w.date,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 25,
                            // width: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              // color: Colors.black.withOpacity(0.5)
                            ),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.timer,
                                    color: Colors.white, size: 12.0),
                                SizedBox(width: 4.0),
                                Text(
                                  w.time,
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                          ),
                        ],
                      ),
                    ],
                  )),
              Positioned(
                top: 200.0,
                left: 10.0,
                child: Container(
                  width: 150.0,
                  child: Text(w.title,
                      style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Positioned(
                  top: 230.0,
                  left: 10.0,
                  child: w.showGoing
                      ? Row(children: [
                          Text('People going',
                              style: TextStyle(
                                  fontFamily: 'Opensans',
                                  fontSize: 13.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100)),
                          SizedBox(width: 30.0),
                          IconButton(
                            padding: EdgeInsets.fromLTRB(13.0, 0, 0, 0),
                            icon: Icon(
                              Icons.people,
                              size: 30,
                            ),
                            // color: user.going[w.title]
                            //     ? Colors.blue
                            //     : Colors.white,
                            onPressed: () {
                              setState(() {
                                // user.going[w.title] = !user.going[w.title];
                                // print(user.going[w.title]);
                              });
                            },
                          ),
                          Text(
                            w.goingGlobal.toString(),
                            style: TextStyle(
                                color: Colors.white54, fontSize: 10.0),
                          ),
                        ])
                      : Text(
                          'Be present!',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 10.0),
                        ))
            ],
          ),
        ));
  }

  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        workshops = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get User Details (for I am going or not?)
    // Get all Workshop JSONS
    // for every json: convert json to workshop object ; List<Widget> cardList = List.append(_buildCard(workshop))

    return Scaffold(
      drawer: getNavDrawer(context),
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(height: 60.0, width: 60.0),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: googleSignIn.currentUser == null
                                    ? AssetImage('assets/profile_test.jpg')
                                    : NetworkImage(profilePhoto),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(25.0)),
                      ),
                      Positioned(
                        left: 5.0,
                        top: 40.0,
                        child: Container(
                          height: 15.0,
                          width: 15.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Colors.green,
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                  width: 1.0)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'The Official',
                    style: TextStyle(
                        fontFamily: 'Opensans',
                        fontSize: 50.0,
                        color: Color(0xFFFD6F4F)),
                  ),
                  Text(
                    'IIT(BHU) App',
                    style: TextStyle(
                      fontFamily: 'Opensans',
                      fontSize: 40.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Most Popular Workshops:',
                        style: TextStyle(
                          fontFamily: 'Opensans',
                          fontSize: 20.0,
                        )),
                    // IconButton(
                    //     icon: Icon(Icons.more_horiz, color: Colors.black),
                    //     onPressed: () {}),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                height: 300.0,
                child: (workshops != null)
                    ? StreamBuilder(
                        stream: workshops,
                        builder: (context, snapshot) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, i) {
                              return _buildCard(
                                  w: Workshop.createWorkshopFromMap(
                                      snapshot.data.documents[i].data));
                            },
                          );
                        },
                      )
                    : Text('Loading'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
