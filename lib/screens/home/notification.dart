import 'package:flutter/material.dart';

class NotificationsPost {
  final String title;
  final String body;
  final String date;
  const NotificationsPost({this.body, this.title, this.date});
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 22.0,
    fontFamily: 'Poppins',
  );

  Widget _getNotificationCard({String title, String body, String date}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white70,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleStyle),
                SizedBox(height: 10.0),
                Text(body),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(date)],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<NotificationsPost> notifs = [];
    notifs
        .add(NotificationsPost(title: 'Hey', body: 'lol', date: '25-07-2020'));
    notifs.add(NotificationsPost(
        date: '25-07-2020',
        title: 'Hey',
        body:
            'lolololololololololololololololololololololololololololololololololololololololololololololololololololoolololololololoolollolololololololololololololoololoo'));

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Notifications',
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _getNotificationCard(
            title: notifs[index].title,
            body: notifs[index].body,
            date: notifs[index].date,
          );
        },
        itemCount: notifs.length,
      ),
    );
  }
}
