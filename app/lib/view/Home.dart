import 'package:app/colors/Colors.dart';
import 'package:app/config/Config.dart';
import 'package:app/presenter/app_icons.dart';
import 'package:app/view/History.dart';
import 'package:app/view/Settings.dart';
import 'package:flutter/material.dart';
import 'Sensors.dart';

enum Pages { SENSORS, HISTORY, SETTINGS }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Widget _selectedPage;

  void setSelectedPage(Pages page) {
    setState(() {
      switch (page) {
        case Pages.SENSORS:
          _selectedPage = Sensors();
          break;
        case Pages.HISTORY:
          _selectedPage = History();
          break;
        case Pages.SETTINGS:
          _selectedPage = Settings();
          break;
        default:
          _selectedPage = Sensors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 300,
        child: Drawer(
          child: Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(25),
                    child: Image(image: AssetImage('assets/images/birlik_mantar.png'))),
                ListTile(
                  leading: Icon(AppIcons.temperature_high),
                  title: Text('Sensorler', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    setSelectedPage(Pages.SENSORS);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(AppIcons.history),
                  title: Text('Gecmis', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    setSelectedPage(Pages.HISTORY);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Ayarlar', style: TextStyle(fontSize: 16)),
                  onTap: () {
                    setSelectedPage(Pages.SETTINGS);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          Config.RECIPIENT_NAME,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: _selectedPage,
    );
  }
}
