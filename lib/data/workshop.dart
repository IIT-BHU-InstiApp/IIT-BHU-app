import 'package:flutter/material.dart';

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
    councils[0]: [
      'Club of Programmers',
      'Robotics Club',
      'SAE',
      'AMC',
      'CSI',
      'Biz',
      'Astro'
    ],
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
  int id;
  String club;
  String smallImageUrl;
  String largeImageUrl;
  String title;
  String date;
  String time;
  // String description;
  // int goingGlobal = 0;
  // bool showGoing = true; //default value is true

  Workshop() {
    date = convertDate(DateTime.now());
    time = converTime(TimeOfDay.now());
  }

  Map<String, dynamic> createMap() {
    return {
      'id': id,
      'club': club,
      'title': title,
      'date': date,
      'time': time,
    };
  }

  static Workshop createWorkshopFromMap(dynamic map) {
    Workshop w = new Workshop();

    w.id = map.id;
    w.club = map.club.name;
    w.title = map.title;
    w.date = map.date;
    w.time = map.time;
    return w;
  }
}

String convertDate(DateTime date) {
  return date.toString().substring(0, 10);
}

String converTime(TimeOfDay time) {
  return time.toString().substring(10, 15);
}

// ! These classes will be used for workshop creation
class WorkshopDetails extends Workshop {
  String description;
  String location;
  String audience;
  String resources;
  List<Contact> contacts;
  String imageUrl;
  String isAttendee;
  String attendees;
}

class Contact {
  int id;
  String name;
  String email;
  String phoneNumber;
  String photoUrl;
}
