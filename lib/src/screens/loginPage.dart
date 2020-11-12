import 'package:fangapp/src/components/customTextField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userName;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  onChangedValue: (String text) async {
                    setState(() { _userName = text; });
                  },
                  icon: Icons.person,
                  hintText: 'Username',
                ),
                CustomTextField(
                  onChangedValue: (String text) async {
                    setState(() { _password = text; });
                  },
                  icon: Icons.lock,
                  hintText: 'Password',
                  isObscure: true,
                ),
              ],
            )
          ),
          Positioned(
              bottom: 70,
              right: 0,
              left: 0,
              child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.yellow), backgroundColor: Colors.black)
              )
          )
        ],
      )
    );
  }
}
