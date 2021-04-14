import 'dart:ui';
import 'package:app/config/Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  RangeValues _currentRangeValues = const RangeValues(0, 20);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "${_currentRangeValues.start.toStringAsFixed(1)}°C - ${_currentRangeValues.end.toStringAsFixed(1)}°C",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(margin: EdgeInsets.only(left: 20), child: Text("0")),
              Expanded(
                child: RangeSlider(
                  values: _currentRangeValues,
                  min: 0,
                  max: 30,
                  labels: RangeLabels(
                    _currentRangeValues.start.toString(),
                    _currentRangeValues.end.toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                    });
                  },
                ),
              ),
              Container(margin: EdgeInsets.only(right: 20), child: Text("30"))
            ],
          ),
        ),
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                backgroundColor: MaterialStateProperty.all(Colors.grey)),
            child: Text(
              "SAVE",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onPressed: () {
              print("object");
              Config.LOWER_LIMIT = double.parse(_currentRangeValues.start.toStringAsFixed(1));
              Config.UPPER_LIMIT = double.parse(_currentRangeValues.end.toStringAsFixed(1));
            })
      ],
    );
  }
}
