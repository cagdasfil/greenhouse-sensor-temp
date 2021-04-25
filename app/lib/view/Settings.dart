import 'dart:ui';
import 'package:app/config/Config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final double minTemp = 0;
  final double maxTemp = 45;

  RangeValues _currentRangeValues = RangeValues(Config.LOWER_LIMIT, Config.UPPER_LIMIT);

  void setTemperatureLimits(double lowerLimit, double upperLimit) async {
    final prefs = await SharedPreferences.getInstance();

    // set value
    Config.LOWER_LIMIT = lowerLimit;
    Config.UPPER_LIMIT = upperLimit;
    prefs.setDouble('UPPER_LIMIT', upperLimit);
    prefs.setDouble('LOWER_LIMIT', lowerLimit);

    Fluttertoast.showToast(
        msg: "Kaydedildi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
                  min: minTemp,
                  max: maxTemp,
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
              Container(margin: EdgeInsets.only(right: 20), child: Text("45"))
            ],
          ),
        ),
        TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all(Colors.grey.shade300)),
            child: Text(
              "Kaydet",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            onPressed: () {
              print("object");
              setTemperatureLimits(double.parse(_currentRangeValues.start.toStringAsFixed(1)),
                  double.parse(_currentRangeValues.end.toStringAsFixed(1)));
            })
      ],
    );
  }
}
