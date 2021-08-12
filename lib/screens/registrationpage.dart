import 'package:connectivity/connectivity.dart';
import 'package:driver/screens/vehicleinfo.dart';
import 'package:driver/widgets/Button.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../brand_colors.dart';
import 'loginpage.dart';


class RegisterationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegisterationPageState createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
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

  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> registerUser() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          status: 'Registering you...',
        ));

    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: emailController.text,
    //       password: passwordController.text
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //     showSnackBar('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //     showSnackBar('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }

    // User user = (await _auth
    //         .createUserWithEmailAndPassword(
    //             email: emailController.text, password: passwordController.text)
    //         .catchError((ex) {
    //   Navigator.pop(context);
    //   PlatformException thisEx = ex;
    //   showSnackBar(thisEx.message);
    // }))
    //     .user;
    User user = (await _auth
        .createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .catchError((ex) {
      Navigator.pop(context);
      FirebaseAuthException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;
    Navigator.pop(context);
    if (user != null) {
      DatabaseReference newUserRef =
      FirebaseDatabase.instance.reference().child('drivers/${user.uid}');

      //Data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      newUserRef.set(userMap);



      Navigator.pushNamed(context, VehicleInfoPage.id);
      return;
    }
    // }on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
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
                    'Create a Driver\'s account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: fullNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
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
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Button(
                          title: 'REGISTER',
                          color: BrandColors.colorGreen,
                          onPressed: () async {
                            //Check Network Availability
                            var connectivityResult =
                            await Connectivity().checkConnectivity();
                            if (connectivityResult ==
                                ConnectivityResult.mobile &&
                                connectivityResult == ConnectivityResult.wifi) {
                              showSnackBar('No internet connectivity');
                            }

                            if (fullNameController.text.length < 3) {
                              showSnackBar('Please provide a valid Full Name');
                              return;
                            }
                            if (emailController.text.length < 10) {
                              showSnackBar(
                                  'Please provide a valid Phone Number');
                              return;
                            }
                            if (phoneController.text.length < 10) {
                              showSnackBar(
                                  'Please provide a valid Phone Number');
                              return;
                            }

                            if (!emailController.text.contains('@')) {
                              showSnackBar('Please provide a valid Email Id');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar('Please provide a valid Password');
                              return;
                            }
                            registerUser();
                          },
                        ),
                      ],
                    ),
                  ),

                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginPage.id, (route) => false);
                      },
                      child: Text('Already have a Driver account? Log in'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
