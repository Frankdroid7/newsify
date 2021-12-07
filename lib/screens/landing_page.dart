import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsify/screens/category_screen.dart';
import 'package:newsify/screens/home_screen.dart';
import 'package:newsify/screens/saved_screen.dart';
import 'package:newsify/screens/search_screen.dart';

import '../constants.dart';

// ignore_for_file: prefer_const_constructors
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentBottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 5,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _listOfWidgets.elementAt(_currentBottomNavIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black,
        currentIndex: _currentBottomNavIndex,
        onTap: (index) => setState(() => _currentBottomNavIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: 'Category'),
        ],
      ),
    );
  }
}

List<Widget> _listOfWidgets = [
  HomeScreen(),
  SearchScreen(),
  CategoryScreen(),
];
