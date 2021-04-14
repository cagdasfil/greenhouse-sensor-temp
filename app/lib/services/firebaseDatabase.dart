import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:app/model/SensorCoordinate.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseDataLoader {
  static final dbRef = FirebaseDatabase.instance.reference().child("server").child("temperatures");
  List<RenderingSensorData> renderingSensorCoordinateData = new List.empty(growable: true);
  int pageCount = 1;
  int maxSensorInSinglePage = 1;
  bool isPageCountSet = false;
  String currentDate;

  Future<List<List<RenderingSensorData>>> getSensorDataFromCloud() async {
    DataSnapshot snapshot = await FirebaseDatabaseDataLoader.dbRef.once();
    Map<String, dynamic> temperaturesTree = snapshot.value.cast<String, dynamic>();
    this.currentDate = temperaturesTree.keys.first;
    Map<String, double> sensorTemperatures = temperaturesTree[this.currentDate].cast<String, double>();
    this.createAndSetSensorCoordinateData(sensorTemperatures);
    return this.createRenderingSensorData();
  }

  void createAndSetSensorCoordinateData(Map<String, double> sensorTemperatures) {
    sensorTemperatures.forEach((key, value) {
      // Key is the name of the string and value is the temperature
      SensorCoordinate coordinate = this.getPageNumberForSensor(key);
      if (!this.isPageCountSet && coordinate.pageNumber > pageCount) {
        this.pageCount = coordinate.pageNumber;
      }
      RenderingSensorData sensorData = RenderingSensorData(key, value.toString(), coordinate);
      this.renderingSensorCoordinateData.add(sensorData);
    });
    Config.PAGE_COUNT = this.pageCount;
    this.isPageCountSet = true;
  }

  List<List<RenderingSensorData>> createRenderingSensorData() {
    List<List<RenderingSensorData>> ret = new List.generate(Config.PAGE_COUNT, (_) => []);
    renderingSensorCoordinateData.forEach((sensorData) {
      // Key is the name of the string and value is the temperature
      ret[sensorData.coordinate.pageNumber].add(sensorData);
    });
    ret.forEach((element) {
      if (element.length > maxSensorInSinglePage) {
        maxSensorInSinglePage = element.length;
      }
    });
    Config.SENSOR_PER_PAGE_COUNT = maxSensorInSinglePage;
    return ret;
  }

  SensorCoordinate getPageNumberForSensor(String sensorName) {
    try {
      List<String> splittedSensorName = sensorName.split(":");
      String coordinate = splittedSensorName[0];
      List<String> splittedCoordinates = coordinate.split("-");
      int pageNumber = int.parse(splittedCoordinates[0]) - 1;
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
