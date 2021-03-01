import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_recommendation/screens/step1.dart';
import 'package:food_recommendation/tabs/mainTab.dart';
import 'package:food_recommendation/tabs/preferrencesTab.dart';
import 'package:food_recommendation/tabs/settingsTab.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 1;
  final MainTab _mainTab = new MainTab();
  final PreferrencesTab _preferrencesTab = new PreferrencesTab();
  final SettingsTab _settingsTab = new SettingsTab();

  Widget _showTab = new MainTab();

  Widget _tabSelector(int tab) {
    switch (tab) {
      case 1:
        return _mainTab;
        break;

      case 0:
        return _preferrencesTab;
        break;
      case 2:
        return _settingsTab;
        break;
      default:
        new Container(
          child: new Center(
            child: new Text('No tab found'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(
            Icons.restaurant_menu,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: Colors.white,
          ),
        ],

        color: Colors.red,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.lightBlue,
        height: 50,
        // index: 1,

        animationDuration: Duration(
          milliseconds: 200,
        ),
        animationCurve: Curves.easeInOut,
        index: pageIndex,
        onTap: (int tappedIndex) {
          setState(() {
            _showTab = _tabSelector(tappedIndex);
          });
        },
      ),
      body: Container(
        child: Center(
          child: _showTab,
        ),
      ),
//        backgroundColor: Colors.red,
    );
  }
}
