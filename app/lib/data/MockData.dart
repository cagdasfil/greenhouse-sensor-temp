import 'dart:math';
import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:app/model/SensorCoordinate.dart';
import 'package:app/model/SensorTemperature.dart';

class MockData {
  List<String> sensorCoordinates;
  List<String> sensorTemperatures;
  List<SensorCoordinate> parsedCoordinates;
  List<SensorTemperature> parsedTemperatures;

  MockData() {
    // Data retrieved from server
    sensorCoordinates = new List.generate(Config.PAGE_COUNT * Config.SENSOR_PER_PAGE_COUNT,
        (index) => "${(index / Config.SENSOR_PER_PAGE_COUNT).floor()}-${index % Config.SENSOR_PER_PAGE_COUNT}:sensor$index");

    // Data retrieved from server
    sensorTemperatures =
        new List.generate(Config.PAGE_COUNT * Config.SENSOR_PER_PAGE_COUNT, (index) => "sensor$index:${randomDoubleInRange(min: 20.0, max: 30.0)}");
  }

  // Random double generator for mocking temperature data
  String randomDoubleInRange({double min = 0.0, double max = 1.0}) {
    return (Random().nextDouble() * (max - min) + min).toStringAsFixed(2);
  }

  List<SensorTemperature> parseSensorTemperature(List<String> sensorTemperatures) {
    List<SensorTemperature> parsedDataList = [];
    for (var data in sensorTemperatures) {
      // after split : [name, temperature]
      List<String> splittedData = data.split(":");
      parsedDataList.add(new SensorTemperature(splittedData[0], double.parse(splittedData[1])));
    }
    return parsedDataList;
  }

  List<SensorCoordinate> parseSensorCoordinate(List<String> sensorCoordinates) {
    List<SensorCoordinate> parsedDataList = [];
    for (var data in sensorCoordinates) {
      // after split : [page, position:name]
      List<String> splittedData = data.split("-");
      // after split : [position, name]
      List<String> splittedPosNameData = splittedData[1].split(":");
      parsedDataList.add(new SensorCoordinate(int.parse(splittedData[0]), int.parse(splittedPosNameData[0]), splittedPosNameData[1]));
    }
    return parsedDataList;
  }

  double findTempByName(String name) {
    SensorTemperature temp = parsedTemperatures.firstWhere((element) => element.name == name);
    return temp.temperature;
  }

  List<List<RenderingSensorData>> getDataForUI() {
    parsedCoordinates = parseSensorCoordinate(sensorCoordinates);
    parsedTemperatures = parseSensorTemperature(sensorTemperatures);
    List<List<RenderingSensorData>> renderingData = new List.generate(Config.PAGE_COUNT, (index) => []);
    for (var data in parsedCoordinates) {
      renderingData[data.pageNumber].add(RenderingSensorData(data.name, findTempByName(data.name).toString(), null));
    }
    return renderingData;
  }
}
