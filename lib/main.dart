import 'package:driver/screens/loginpage.dart';
import 'package:driver/screens/mainpage.dart';
import 'package:driver/screens/registrationpage.dart';
import 'package:driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'dataprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:266062607428:android:daec82ca50220e4dfc3811',
      apiKey: 'AIzaSyCUbwWGRKjzOeWlHp38bcahDmDADE0nlAk',
      projectId: 'geetaxi-27cbe',
      messagingSenderId: '266062607428',
      databaseURL: 'https://geetaxi-27cbe-default-rtdb.firebaseio.com/',
    )
        : FirebaseOptions(
      appId: '1:266062607428:android:daec82ca50220e4dfc3811',
      apiKey: 'AIzaSyCUbwWGRKjzOeWlHp38bcahDmDADE0nlAk',
      messagingSenderId: '266062607428',
      projectId: 'geetaxi-27cbe',
      databaseURL: 'https://geetaxi-27cbe-default-rtdb.firebaseio.com/',
    ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Gee Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: (FirebaseAuth.instance.currentUser !=null) ? LoginPage.id : MainPage.id,
        routes: {
          RegisterationPage.id: (context) => RegisterationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
        },
      ),
    );
  }
}

