import 'package:connectivity/connectivity.dart';
import 'package:driver/screens/registrationpage.dart';
import 'package:driver/widgets/Button.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../brand_colors.dart';
import 'mainpage.dart';


class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user = FirebaseAuth.instance.currentUser;
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          Button(
            title: 'No',
            color: Color(0xFF167F67),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          Button(
            title: 'Yes',
            color: Color(0xFF167F67),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    ) ??
        false;
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //SnackBar Function
  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //Login Function
  void login() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Logging you in',
            ));

    // try {
    //   UserCredential userCredential = await _auth.signInWithEmailAndPassword(
    //       email: emailController.text,
    //       password: passwordController.text
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     showSnackBar('No user found for that email.');
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     showSnackBar('Wrong password provided for that user.');
    //     print('Wrong password provided for that user.');
    //   }
    // }

    User user = (await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .catchError((ex) {
      Navigator.pop(context);
      FirebaseAuthException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('drivers/${user.uid}');

      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => true);
        } else{
          Navigator.pop(context);
          showSnackBar('Rider account exists with this email.');
        }
      });
      return;
      //Verify Login
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Image(
                    alignment: Alignment.center,
                    height: 100.0,
                    width: 100.0,
                    image: AssetImage('images/logo.png'),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Sign In as a Driver',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Button(
                          title: 'LOGIN',
                          color: BrandColors.colorGreen,
                          onPressed: () async {
                            //Check Network Availability
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.mobile &&
                                connectivityResult == ConnectivityResult.wifi) {
                              showSnackBar('No internet connectivity');
                            }
                            if (!emailController.text.contains('@')) {
                              showSnackBar('Please provide a valid Email Id');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar('Please provide a valid Password');
                              return;
                            }
                            login();
                          },
                        ),
                      ],
                    ),
                  ),

                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, RegisterationPage.id, (route) => false);
                      },
                      child: Text('Don\'t have an account, sign up here'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
