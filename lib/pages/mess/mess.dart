import 'package:flutter/material.dart';
import 'package:iit_app/ui/drawer.dart';

class MessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mess Management"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        drawer: SideBar(context: context),
        body: Container(
            child: Center(
          child: Text("Manage Your Entire mess here.. Under DEVELOPMENT"),
        )),
      ),
    );
  }
}
