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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.35),
            child: Center(
              child: Column(
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
          ),
          Positioned(
              bottom: 70,
              right: 0,
              left: 0,
              child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.yellow), backgroundColor: Colors.black)
              )
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'lib/src/assets/login-cloud-top.png',
              width: size.width * 1.1,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'lib/src/assets/login-cloud-bottom.png',
              width: size.width * 0.7,
            ),
          )
        ],
      )
    );
  }
}
