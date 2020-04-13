import 'package:flutter/material.dart';

class Workshop {
  int id;
  int clubId;
  String club;
  int councilId;
  String smallImageUrl;
  String largeImageUrl;
  String title;
  String date;
  String time;

  Workshop() {
    date = convertDate(DateTime.now());
    time = converTime(TimeOfDay.now());
  }

  static Workshop createWorkshopFromMap(dynamic map) {
    Workshop w = new Workshop();
    w.id = map.id;
    w.clubId = map.club.id;
    w.club = map.club.name;
    w.councilId = map.club.council;
    w.smallImageUrl = map.club.small_image_url;
    w.largeImageUrl = map.club.large_image_url;
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
