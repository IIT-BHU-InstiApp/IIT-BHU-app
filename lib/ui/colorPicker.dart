import 'package:flutter/material.dart';
import 'package:iit_app/external_libraries/circle_color_picker.dart';

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

// TODO: USE this class to set colors for background and text

class _ColorPickerState extends State<ColorPicker> {
  Color _currentColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _currentColor,
        title: const Text('Circle color picker sample'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: CircleColorPicker(
            initialColor: _currentColor,
            onChanged: _onColorChanged,
            colorCodeBuilder: (context, color) {
              return Text(
                'rgb(${color.red}, ${color.green}, ${color.blue})',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onColorChanged(Color color) {
    setState(() => _currentColor = color);
  }
}
