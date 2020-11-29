import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InternetErrorFlushbar {
  Flushbar _flushbar;
  bool _onScreen;

  InternetErrorFlushbar() {
    _onScreen = false;
    _flushbar = Flushbar(
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
    _flushbar.onStatusChanged = _handleStatus;
  }

  showFlushbar(BuildContext context) async {
    if (_onScreen) return;
    await Future.delayed(Duration(milliseconds: 250));
    _flushbar..show(context);
  }

  void _handleStatus(FlushbarStatus status) {
    switch (status) {
      case FlushbarStatus.SHOWING:
        _onScreen = true;
        break;
      default:
        _onScreen = false;
    }
  }
}
