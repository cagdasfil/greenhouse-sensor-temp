import 'dart:ffi';

import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:app/model/SensorCoordinate.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseDataLoader {
  static final dbRef = FirebaseDatabase.instance.reference().child("server").child("temperatures");

  Future<List<List<RenderingSensorData>>> getSensorDataFromCloud() async {
    DataSnapshot snapshot = await FirebaseDatabaseDataLoader.dbRef.once();
    Map<String, dynamic> temperaturesTree = snapshot.value.cast<String, dynamic>();
    String currentDate = temperaturesTree.keys.first;
    Map<String, double> sensorTemperatures = temperaturesTree[currentDate].cast<String, double>();
    return this.createRenderingSensorData(sensorTemperatures);
  }

  List<List<RenderingSensorData>> createRenderingSensorData(Map<String, double> sensorTemperatures) {
    List<List<RenderingSensorData>> ret = new List.generate(Config.PAGE_COUNT, (_) => []);
    sensorTemperatures.forEach((key, value) {
      // Key is the name of the string and value is the temperature
      SensorCoordinate coordinate = this.getPageNumberForSensor(key);
      RenderingSensorData sensorData = RenderingSensorData(key, value.toString(), coordinate);
      ret[coordinate.pageNumber].add(sensorData);
    });
    return ret;
  }

  SensorCoordinate getPageNumberForSensor(String sensorName) {
    try {
      List<String> splittedSensorName = sensorName.split(":");
      String coordinate = splittedSensorName[0];
      List<String> splittedCoordinates = coordinate.split("-");
      int pageNumber = int.parse(splittedCoordinates[0]);
      int positionInPage = int.parse(splittedCoordinates[1]);
      String name = splittedSensorName[1];
      return SensorCoordinate(pageNumber, positionInPage, name);
    } on FormatException {
      return SensorCoordinate(0, 0, sensorName);
    } catch (e) {
      print(e);
      return e;
    }
  }
}
