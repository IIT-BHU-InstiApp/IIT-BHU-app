import 'package:flutter/material.dart';
import 'package:iit_app/model/colorConstants.dart';

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
        ),
      ],
    );
  }

  static Row getHeading({IconData icon, String title}) {
    Color color = ColorConstants.headingColor;
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
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            ColorConstants.workshopContainerBackground.withAlpha(0),
            ColorConstants.workshopContainerBackground
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  static Container getToolbar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: BackButton(color: Colors.lightGreen),
    );
  }

  static Padding getTag({String tag, int index}) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.grey,
    ];
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              tag,
            ),
          ),
        ],
      ),
    );
  }
}
