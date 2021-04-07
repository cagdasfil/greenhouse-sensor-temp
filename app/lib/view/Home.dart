import 'package:app/colors/Colors.dart';
import 'package:app/config/Config.dart';
import 'package:flutter/material.dart';
import 'Tabs.dart';

//TODO: Move the drawer to here, update myApp in the main.

enum Section {
  TABS,
  HISTORY,
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Widget body;
  Section section;
  @override
  Widget build(BuildContext context) {
    /// You can easily control the section for example inside the initState where you check
    /// if the user logged in, or other related logic
    switch (section) {

      /// Display the home section, simply by
      case Section.TABS:
        body = Tabs();
        break;

      case Section.HISTORY:
        body = null;
        break;
    }

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
                  title: Text('Sensorler'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Gecmis'),
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
          Config.RECIPIENT_NAME,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
