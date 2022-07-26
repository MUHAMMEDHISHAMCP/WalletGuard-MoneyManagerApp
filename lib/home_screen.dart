import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/transaction/catoreries/category_page.dart';
import 'package:money_manager/transaction/chart/pie_chart.dart';
import 'package:money_manager/transaction/settingss/settings.dart';
import 'package:money_manager/transaction/transaction.dart';
import 'package:money_manager/utilities.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final screens = [
    TransactionScreen(),
    const CategoryPage(),
    const ChartScreen(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: screens[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(
            Icons.category,
            size: 30,
          ),
          Icon(
            Icons.pie_chart,
            size: 30,
          ),
          Icon(
            Icons.settings,
            size: 30,
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
        buttonBackgroundColor: maincolor,
        backgroundColor: Colors.white,
        height: 60.0,
        color: maincolor,
      ),
    );
  }
}
