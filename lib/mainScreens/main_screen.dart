import 'package:go/mainScreens/ride_request.dart';
import 'package:go/tabPages/earning_tab.dart';
import 'package:go/tabPages/home_tab.dart';
import 'package:go/tabPages/profile_tab.dart';
import 'package:go/tabPages/ratings_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> _children = [
    HomeTabPage(),
    EarningsTabPage(),
    RideRequest(),
    ProfileTabPage(),
  ];

  void OnTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
  }

  @override
  void initState() {
    super.initState();
    // tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //onItemClicked(selectedIndex);
    return Scaffold(
      body: _children[Provider.of<ValueNotifier<int>>(context).value],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Request",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        unselectedItemColor: Colors.white54,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: Provider.of<ValueNotifier<int>>(context).value,
        onTap: OnTappedBar,
      ),
    );
  }
}
