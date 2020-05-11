import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/circle_color_picker.dart';

class ColorPicker {
  final ValueNotifier<Color> colorListener;
  TextEditingController _colorCodeController = TextEditingController();

  ColorPicker(this.colorListener) {
    _colorCodeController.text =
        colorListener.value.toString().substring(6).split(')')[0];
  }

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
              _colorCodeController.text =
                  colorListener.value.toString().substring(6).split(')')[0];
            },
            colorCodeBuilder: (context, color) {
              return Container(
                padding: EdgeInsets.only(right: 70, left: 70),
                child: TextFormField(
                  controller: _colorCodeController,
                  onChanged: (value) {
                    colorListener.value = Color(int.parse(value));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
