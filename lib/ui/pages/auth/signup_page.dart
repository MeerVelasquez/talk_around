import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/signup.png'),
                fit: BoxFit.cover,
              ),
            ),
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
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      )
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
                      onPressed: () {
                        // Get.toNamed('/home');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE7FCFD)),
                      )),
                ),
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
                    icon:
                        Image.asset('assets/google.png', width: 30, height: 30),
                    label: Row(
                      children: [
                        SizedBox(
                            width: 80.0), // Add spacing between icon and text
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
