import 'package:url_launcher/url_launcher.dart';

openGithub(String username) async {
  String url = 'https://github.com/$username';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
