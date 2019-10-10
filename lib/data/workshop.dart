import 'package:flutter/material.dart';

class Workshop {
  static const councils = ['SNTC', 'FMC', 'Cultural', 'Social', 'Sports'];
  static Map<String, List<String>> clubs = {
    null: [],
    councils[0]: ['COPS', 'Robotics', 'SAE', 'AMC', 'CSI', 'Biz'],
    councils[1]: ['Photography', 'Animation', 'Cine'],
    councils[2]: ['IMC', 'WMC', 'Masquarades'],
    councils[3]: ['SPC', 'Sahyog'],
    councils[4]: ['Hockey', 'Cricket', 'Badminton'],
  };
  static Map<String, String> imgPath = {
    clubs[councils[0]][0]: 'assets/COPS.png',
    clubs[councils[0]][1]: 'assets/Robotics.jpg',
  };
  String title;
  String date;
  String time;
  String council;
  String club;
  String description;
  int goingGlobal = 0;
  bool showGoing = true; //default value is true

  Workshop() {
    date = convertDate(DateTime.now());
    time = converTime(TimeOfDay.now());
  }

  save() {
    print('saving user using a web service');
    print(
        '$council, $club, $title, $description, $showGoing, $date, $time');
  }
}

String convertDate(DateTime date) {
  return date.toString().substring(0, 10);
}

String converTime(TimeOfDay time) {
  return time.toString().substring(10, 15);
}
