import 'package:app/colors/Colors.dart';
import 'package:app/presenter/app_icons.dart';
import 'package:app/view/History.dart';
import 'package:app/view/Settings.dart';
import 'package:flutter/material.dart';
import 'Sensors.dart';

class _Page {
  String _drawerTitle;
  String _appBarTitle;
  Icon _icon;
  Widget _body;
  _Page(this._drawerTitle, this._appBarTitle, this._icon, this._body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedPageIndex = 0;
  List<_Page> pages = [
    _Page("Sensörler", "Sensörler", Icon(AppIcons.temperature_high), Sensors()),
    _Page("Geçmiş", "Geçmiş", Icon(AppIcons.history), History()),
    _Page("Ayarlar", "Ayarlar", Icon(Icons.settings), Settings())
  ];

  void setSelectedPageIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: 300,
        child: Drawer(
          child: ListTileTheme(
            iconColor: Colors.grey,
            textColor: Colors.grey,
            style: ListTileStyle.drawer,
            selectedColor: Colors.white,
            selectedTileColor: AppColors.primary,
            child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 80, 0, 40),
                          padding: EdgeInsets.all(25),
                          child: Image(image: AssetImage('assets/images/birlik_mantar.png')))
                    ] +
                    List.generate(
                        pages.length,
                        (index) => ListTile(
                              selected: index == _selectedPageIndex,
                              leading: Container(margin: EdgeInsets.only(left: 5), child: pages[index]._icon),
                              title: Text(pages[index]._drawerTitle, style: TextStyle(fontSize: 16)),
                              onTap: () {
                                setSelectedPageIndex(index);
                                Navigator.pop(context);
                              },
                            ))),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          pages[_selectedPageIndex]._appBarTitle,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: pages[_selectedPageIndex]._body,
    );
  }
}
