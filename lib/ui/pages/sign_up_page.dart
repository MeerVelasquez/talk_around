import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:talk_around/domain/models/user.dart';

import 'package:talk_around/ui/controllers/app_controller.dart';
import 'package:talk_around/ui/routes.dart';
import 'package:talk_around/ui/widgets/button_primary_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with WidgetsBindingObserver {
  final AppController _appController = Get.find<AppController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _appController.stopListeningGeoloc().catchError(logError);
  }

  void onSubmit() async {
    try {
      BuildContext context = _scaffoldKey.currentContext!;
      FocusScope.of(context).requestFocus(FocusNode());

      final FormState? form = _formKey.currentState;
      form!.save();

      await _appController.signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _usernameController.text.trim(),
        _passwordController.text,
      );
    } catch (err) {
      logError(err);
      if (_scaffoldKey.currentContext != null) {
        showDialog(
          context: _scaffoldKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign up failed"),
              content:
                  const Text("Please try again with different credentials."),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
      return;
    }
  }

  void onSignInWithGoogle() async {
    try {
      await _appController.signInWithGoogle();
    } catch (err) {
      logError(err);
      if (_scaffoldKey.currentContext != null) {
        showDialog(
          context: _scaffoldKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Sign in failed"),
              content:
                  const Text("Please check your credentials and try again."),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
      return;
    }
  }

  void onSignInAsAnonymous() async {
    // try {
    //   await _appController.signInAsAnonymous();
    // } catch (err) {
    //   logError(err);
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/login.png'),
              fit: BoxFit.cover,
            ),
          )),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/img/logo.png',
                      width: 120,
                      height: 120,
                    ),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                      controller: _nameController,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                      controller: _emailController,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                      controller: _usernameController,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                    ),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                      controller: _passwordController,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                    ),
                                    child: TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Confirm password',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                      controller: _confirmPasswordController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                                width: 300,
                                height: 50,
                                child: ButtonPrimaryWidget(
                                  text: 'Sign Up',
                                  onPressed: onSubmit,
                                )),
                            SizedBox(height: 30.0),
                            Container(
                              width: 400,
                              height: 50,
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFFE7FCFD)),
                                ),
                                onPressed: onSignInWithGoogle,
                                icon: Image.asset('assets/img/google.png',
                                    width: 30, height: 30),
                                label: Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            80.0), // Add spacing between icon and text
                                    Text(
                                      'Sign Up with Google',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF013E6A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              width: 400,
                              height: 50,
                              child: TextButton(
                                // style: ButtonStyle(
                                //   backgroundColor:
                                //       MaterialStateProperty.all(Color(0xFFE7FCFD)),
                                // ),
                                onPressed: onSignInAsAnonymous,
                                child: Text(
                                  'Continue as guest',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
