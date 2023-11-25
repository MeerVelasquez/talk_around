import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:talk_around/ui/controllers/app_controller.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with WidgetsBindingObserver {
  final AppController _appController = Get.find<AppController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver(this);
  }

  void onSubmit() async {
    try {
      BuildContext context = _scaffoldKey.currentContext!;
      FocusScope.of(context).requestFocus(FocusNode());

      final FormState? form = _formKey.currentState;
      form!.save();

      await _appController.signIn(
          _emailController.text.trim(), _passwordController.text);
    } catch (err) {
      logError(err);
      return;
    }
  }

  void onPressSignUp() {
    _appController.goToSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/logo.png'),
                    SizedBox(height: 20.0),
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
                              border: Border.all(color: Colors.blueGrey),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.person),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              controller: _emailController,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.blueGrey),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                              controller: _passwordController,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF013E6A))),
                          onPressed: onSubmit,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE7FCFD)),
                          )),
                    ),
                    // SizedBox(height: 15.0),
                    // Text('Forgot Password?',
                    //     style: TextStyle(
                    //       fontFamily: 'Montserrat',
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.w600,
                    //     )),
                    SizedBox(height: 30.0),
                    Container(
                      width: 400,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7FCFD)),
                        ),
                        onPressed: () {},
                        icon: Image.asset('assets/google.png',
                            width: 30, height: 30),
                        label: Row(
                          children: [
                            SizedBox(
                                width:
                                    80.0), // Add spacing between icon and text
                            Text(
                              'Sign In with Google',
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
                    SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: onPressSignUp,
                      child: const Text('Don\'t have an account? Sign Up',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF012E4D),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(-1.5, -1.5),
                                    color: Colors.white),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(1.5, -1.5),
                                    color: Colors.white),
                                Shadow(
                                    // topRight
                                    offset: Offset(1.5, 1.5),
                                    color: Colors.white),
                                Shadow(
                                    // topLeft
                                    offset: Offset(-1.5, 1.5),
                                    color: Colors.white),
                              ])),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
