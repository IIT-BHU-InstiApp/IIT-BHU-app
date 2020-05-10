import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/circle_color_picker.dart';

class ColorPicker {
  final ValueNotifier<Color> colorListener;

  ColorPicker(this.colorListener);

  getColorPickerDialogBox(context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        actions: <Widget>[
          CircleColorPicker(
            initialColor: colorListener.value,
            onChanged: (color) {
              colorListener.value = color;
            },
            colorCodeBuilder: (context, color) {
              return Text(
                color.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
