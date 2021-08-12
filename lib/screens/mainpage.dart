import 'package:driver/tabs/earningstab.dart';
import 'package:driver/tabs/hometab.dart';
import 'package:driver/tabs/profiletab.dart';
import 'package:driver/tabs/ratingstab.dart';
import 'package:driver/widgets/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../brand_colors.dart';
import 'loginpage.dart';


class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {

  void _signOut() async {
    await FirebaseAuth.instance.signOut();

  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to logout?'),
        actions: <Widget>[
          Button(
            title: 'No',
            color: Color(0xFF167F67),
            onPressed: () async {
              Navigator.of(context).pop(false);
            },
          ),
          Button(
            title: 'Yes',
            color: Color(0xFF167F67),
            onPressed: () async {
              _signOut();
              Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
            },

          ),
        ],
      ),
    ) ??
        false;
  }

  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(

        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTab(),
            EarningsTab(),
            ProfileTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Earnings',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          currentIndex:  selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: BrandColors.colorOrange,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: onItemClicked,
        ),
      ),
    );
  }
}
