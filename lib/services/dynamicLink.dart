import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:iit_app/model/built_post.dart';

class DynamicLinkService {
  static Future<Uri> createDynamicLink(
      {int id, bool isPast, bool isClub}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://litehai.page.link',
      link: isPast == null
          ? Uri.parse('https://litehai.page.link.com/?id=$id&isClub=$isClub')
          : Uri.parse('https://litehai.page.link.com/?id=$id&isPast=$isPast'),
      androidParameters: AndroidParameters(
        packageName: 'com.iitbhu.litehai',
      ),
    );

    Uri url;
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;

    return url;
  }
}
