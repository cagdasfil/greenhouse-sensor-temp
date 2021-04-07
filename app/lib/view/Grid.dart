import 'dart:ffi';

import 'package:app/colors/Colors.dart';
import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:flutter/material.dart';

class SensorGrid extends StatelessWidget {
  final List<RenderingSensorData> data;
  SensorGrid(this.data);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        padding: EdgeInsets.fromLTRB(30 / Config.SENSOR_PER_ROW_COUNT, 30 / Config.SENSOR_PER_ROW_COUNT, 30 / Config.SENSOR_PER_ROW_COUNT, 100),
        shrinkWrap: true,
        crossAxisCount: Config.SENSOR_PER_ROW_COUNT,
        children: List<SensorGridItem>.generate(Config.SENSOR_PER_PAGE_COUNT, (index) => SensorGridItem(data[index].name, data[index].temperature)),
      ),
    );
  }
}

class SensorGridItem extends StatelessWidget {
  final String name;
  final String temperature;
  SensorGridItem(this.name, this.temperature);

  @override
  Widget build(BuildContext context) {
    Color sensorColor;
    double temp = double.parse(temperature);
    if (temp > Config.UPPER_LIMIT || temp < Config.LOWER_LIMIT) {
      sensorColor = Colors.red;
    } else {
      sensorColor = Colors.green;
    }
    return Container(
      margin: EdgeInsets.all(10),
      //color: Colors.red,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: sensorColor,
            //gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [AppColors.tempBlue, AppColors.tempRed])
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 48 / Config.SENSOR_PER_ROW_COUNT, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "$temperature °C",
                  style: TextStyle(fontSize: 60 / Config.SENSOR_PER_ROW_COUNT, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
