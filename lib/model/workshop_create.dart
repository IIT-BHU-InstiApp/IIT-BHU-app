import 'package:flutter/material.dart';

class Workshop {
  static const councils = ['SNTC', 'FMC', 'Cultural', 'Social', 'Sports'];
  static Map<String, List<String>> clubs = {
    null : [],
    councils[0]: ['COPS', 'Robotics', 'SAE', 'AMC', 'CSI', 'Biz'],
    councils[1]: ['Photography', 'Animation', 'Cine'],
    councils[2]: ['IMC', 'WMC', 'Masquarades'],
    councils[3]: ['SPC', 'Sahyog'],
    councils[4]: ['Hockey', 'Cricket', 'Badminton'],
  };
  String title = '';
  String description = '';
  String selectedCouncil;
  String selectedClub;
  bool showGoing = true;
  String date;
  String time;

  Workshop()
  {
    date = DateTime.now().toString().substring(0, 10);
    time = TimeOfDay.now().toString().substring(10, 15);
  }

  save() {
    print('saving user using a web service');
  }
}
