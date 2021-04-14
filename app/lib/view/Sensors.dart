import 'package:app/colors/Colors.dart';
import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:app/services/firebaseDatabase.dart';
import 'package:flutter/material.dart';
import 'package:app/view/Grid.dart';

class Sensors extends StatefulWidget {
  @override
  _SensorsState createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;
  FirebaseDatabaseDataLoader dataLoader = FirebaseDatabaseDataLoader();
  Future<List<List<RenderingSensorData>>> _sensorRawData;

  @override
  void initState() {
    super.initState();
    _sensorRawData = dataLoader.getSensorDataFromCloud();
    _sensorRawData.then((value) {
      _tabController = TabController(vsync: this, length: Config.PAGE_COUNT);
      _tabController.addListener(_setActiveTabIndex);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sensorRawData,
        builder: (BuildContext context, AsyncSnapshot<List<List<RenderingSensorData>>> sensorRawData) {
          if (!sensorRawData.hasData) {
            // while data is loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded:
            final sensorData = sensorRawData.data;
            List<Widget> _grids = List<Widget>.generate(Config.PAGE_COUNT, (index) => SensorGrid(sensorData[index]));
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(margin: EdgeInsets.only(right: 10), child: Icon(Icons.date_range)),
                    Text(
                      dataLoader.currentDate.split(' ')[0].replaceAll('-', '/'),
                      textAlign: TextAlign.center,
                    ),
                    Container(margin: EdgeInsets.fromLTRB(20, 0, 10, 0), child: Icon(Icons.access_time_sharp)),
                    Text(
                      dataLoader.currentDate.split(' ')[1],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              body: Container(
                color: AppColors.background,
                child: TabBarView(
                  controller: _tabController,
                  children: _grids,
                ),
              ),
              extendBody: true,
              bottomNavigationBar: Container(
                margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
                child: BottomAppBar(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: AppColors.primary, width: 0.5)),
                      child: TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.primary),
                        tabs: List.generate(
                            Config.PAGE_COUNT,
                            (index) => Container(
                                height: 50,
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  "TAB ${index + 1}",
                                  style: TextStyle(
                                      color: _activeTabIndex == index ? Colors.white : AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ))),
                        controller: _tabController,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
