import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternetErrorFlushbar {
  Flushbar flushbar;
  bool onScreen;

  InternetErrorFlushbar() {
    onScreen = false;
    flushbar = Flushbar(
      title: 'Internet Error',
      message: 'Could not connect to internet, please check your connection.',
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      isDismissible: false,
      icon: Icon(Icons.error_outline, color: Colors.red, size: 36),
    );
    flushbar.onStatusChanged = _handleStatus;
  }

  void _handleStatus(FlushbarStatus status) {
    switch (status) {
      case FlushbarStatus.SHOWING:
        onScreen = true;
        break;
      default:
        onScreen = false;
    }
  }
}
