import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';

class Workshop {
  static const councils = [
    'SnTC',
    'FMC',
    'Cultural',
    'Social Service',
    'Sports'
  ];
  static Map<String, List<String>> clubs = {
    null: [],
    councils[0]: ['COPS', 'Robotics', 'SAE', 'AMC', 'CSI', 'Biz', 'Astro'],
    councils[1]: [
      'Photography',
      'Animation',
      'Cinematography',
      'Creative Design',
      'Outreach',
      'Media'
    ],
    councils[2]: [
      'IMC',
      'WMC',
      'Dramatics',
      'FAC',
      'Literary',
      'Quiz',
      'Dance'
    ],
    councils[3]: [
      'Social Projects',
      'Sahyog',
      'Kashi Utkarsh',
      'Health and Hygiene'
    ],
    councils[4]: ['Sports'],
  };
  static Map<String, String> imgPath = {
    clubs[councils[0]][0]: 'assets/COPS.png',
    clubs[councils[0]][1]: 'assets/Robotics.jpg',
    clubs[councils[0]][2]: 'assets/SAE.jpg',
    clubs[councils[0]][3]: 'assets/AMC.png',
    clubs[councils[0]][4]: 'assets/CSI.png',
    clubs[councils[0]][5]: 'assets/Biz.jpeg',
    clubs[councils[0]][6]: 'assets/Astro.jpeg',
    clubs[councils[1]][0]: 'assets/iitbhu.jpeg',
    clubs[councils[1]][1]: 'assets/iitbhu.jpeg',
    clubs[councils[1]][2]: 'assets/iitbhu.jpeg',
    clubs[councils[1]][3]: 'assets/iitbhu.jpeg',
    clubs[councils[1]][4]: 'assets/iitbhu.jpeg',
    clubs[councils[1]][5]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][0]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][1]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][2]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][3]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][4]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][5]: 'assets/iitbhu.jpeg',
    clubs[councils[2]][6]: 'assets/iitbhu.jpeg',
    clubs[councils[3]][0]: 'assets/iitbhu.jpeg',
    clubs[councils[3]][1]: 'assets/iitbhu.jpeg',
    clubs[councils[3]][2]: 'assets/iitbhu.jpeg',
    clubs[councils[3]][3]: 'assets/iitbhu.jpeg',
    clubs[councils[4]][0]: 'assets/iitbhu.jpeg',
  };
  String title;
  String date;
  String time;
  String council;
  String club;
  String description;
  int goingGlobal = 0;
  bool showGoing = true; //default value is true
  int id;

  Workshop() {
    date = convertDate(DateTime.now());
    time = converTime(TimeOfDay.now());
  }

  Map<String, dynamic> createMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
      'council': council,
      'club': club,
      'description': description,
      'goingGlobal': goingGlobal,
      'showGoing': showGoing,
      'id': id,
    };
  }

  static Workshop createWorkshopFromMap(dynamic map) {
    Workshop w = new Workshop();
    w.club = 'COPS';
    w.council = 'SnTC';
    w.title = map.title;
    w.date = map.date;
    w.time = map.time;
    w.description = 'ejnfe';
    w.goingGlobal = 45;
    w.showGoing = true;
    w.id = 0;
    return w;
  }
}

String convertDate(DateTime date) {
  return date.toString().substring(0, 10);
}

String converTime(TimeOfDay time) {
  return time.toString().substring(10, 15);
}
