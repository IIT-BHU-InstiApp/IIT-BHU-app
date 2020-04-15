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


  static Workshop createWorshopFromMap(dynamic map) {
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