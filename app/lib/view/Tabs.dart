import 'package:app/colors/Colors.dart';
import 'package:app/config/Config.dart';
import 'package:app/model/RenderingSensorData.dart';
import 'package:app/presenter/app_icons.dart';
import 'package:app/services/firebaseDatabase.dart';
import 'package:flutter/material.dart';
import 'package:app/view/Grid.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
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
              drawer: Container(
                width: 250,
                child: Drawer(
                  child: Container(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                          height: 88,
                          child: DrawerHeader(
                            child: Text(
                              Config.RECIPIENT_NAME,
                              style: TextStyle(fontSize: 32, color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(AppIcons.temperature_high),
                          title: Text('Sensorler', style: TextStyle(fontSize: 16)),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                        ListTile(
                          leading: Icon(AppIcons.history),
                          title: Text(
                            'Gecmis',
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Ayarlar', style: TextStyle(fontSize: 16)),
                          onTap: () {
                            // Update the state of the app.
                            // ...
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              appBar: AppBar(
                title: Text(
                  dataLoader.currentDate,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: AppColors.primary,
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
                        indicator: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: AppColors.primary),
                        tabs: List.generate(
                            Config.PAGE_COUNT,
                            (index) => Container(
                                height: 50,
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  "TAB ${index + 1}",
                                  style: TextStyle(
                                      color: _activeTabIndex == index ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
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
