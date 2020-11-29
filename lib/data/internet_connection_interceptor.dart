import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:iit_app/model/appConstants.dart';

class InternetConnectionInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final connectivityResult =
        await AppConstants.connectionStatus.checkConnection();

    if (connectivityResult != true) {
      throw InternetConnectionException();
    }
    return request;
  }
}

class InternetConnectionException implements Exception {
  final message = 'Could not connect to internet, please check your connection';
  @override
  String toString() => message;
}
