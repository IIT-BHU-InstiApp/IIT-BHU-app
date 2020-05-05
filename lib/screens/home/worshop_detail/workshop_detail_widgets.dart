import 'package:flutter/material.dart';

class WorkshopDetailWidgets {
  static Column getPanelHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff00c6ff),
            borderRadius: BorderRadius.circular(2.0),
          ),
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 2 - 12.0, 10.0, 0.0, 0.0),
          height: 4.0,
          width: 24.0,
          //color: new Color(0xff00c6ff)
        ),
      ],
    );
  }

  static Row getHeading({IconData icon, String title}) {
    Color color = Color(0xFF736AB7);
    TextStyle headingStyle = TextStyle(
        fontSize: 22.0,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w300,
        color: color);
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 5.0),
        Text(
          title,
          style: headingStyle,
        ),
      ],
    );
  }

  static Container getGradient() {
    return Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[new Color(0x00736AB7), new Color(0xFF736AB7)],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  static Container getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: new BackButton(color: Colors.lightGreen),
    );
  }
}
