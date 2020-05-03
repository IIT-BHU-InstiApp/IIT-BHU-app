import 'package:flutter/material.dart';
import 'package:iit_app/screens/drawer.dart';

class ComplaintsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complaints & Suggestions"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: SideBar(context: context),
      body: Container(
          child: Center(
        child: Text("submit your complaints here.. Under DEVELOPMENT"),
      )),
    );
  }
}
