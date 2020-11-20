import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fangapp/src/components/customTextField.dart';
import 'package:fangapp/src/utils/snack-bar.dart';
import 'mangasListPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FocusNode _mailNode;
  FocusNode _passwordNode;

  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _connecting = false;

  double _loginBottom;
  double _loginOpacity;

  @override
  void initState() {
    super.initState();
    _loginBottom = -100;
    _loginOpacity = 0;
    _mailController.text = 'guillaume.camanes@gmail.com';
    _passwordController.text = 'FAbalaise';

    _mailNode = FocusNode();
    _passwordNode = FocusNode();
    Future.delayed(const Duration(milliseconds: 500), () => showLogin());
  }

  @override
  void dispose() {
    _mailNode.dispose();
    _passwordNode.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showLogin() {
    Size size = MediaQuery.of(context).size;
    setState(() {
      _loginBottom = size.height * 0.25;
      _loginOpacity = 1;
    });
  }

  void hideLogin() {
    setState(() {
      _loginBottom = -100;
      _loginOpacity = 0;
    });
  }

  void login() async {
    setState(() {
      _connecting = true;
    });
    hideLogin();
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: _mailController.text, password: _passwordController.text);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MangasListPage()),
            (route) => false,
      );
    } on FirebaseAuthException catch(e) {
      String errorMessage = "";
      switch(e.code) {
        case 'network-request-failed':
          errorMessage = "No connectivity. Please check your internet connection";
          break;
        default:
          errorMessage = "Mail not found or incorrect password. Please try again";
      }
      SnackBarManager.showMessage(context, errorMessage);
      setState(() {
        _connecting = false;
      });
      showLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {FocusScope.of(context).unfocus();},
        child: Scaffold(
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
                              controller: _mailController,
                              icon: Icons.person,
                              hintText: 'Mail',
                              focusNode: _mailNode,
                              onSubmitted: (String str) {FocusScope.of(context).requestFocus(_passwordNode);},
                              inputAction: TextInputAction.next,
                            ),
                            CustomTextField(
                              controller: _passwordController,
                              icon: Icons.lock,
                              hintText: 'Password',
                              isObscure: true,
                              focusNode: _passwordNode,
                            ),
                          ],
                        )
                    ),
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
                ),
                AnimatedPositioned(
                    bottom: _loginBottom,
                    right: 0,
                    left: 0,
                    duration: Duration(seconds: 1),
                    child: AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: _loginOpacity,
                      child: Center(
                        child: TextButton(
                          child: Container(
                            width: size.width * 0.755,
                            height: 35,
                            child: Align(
                              child: _connecting
                                  ? Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white), backgroundColor: Colors.amber)
                              )
                                  : Text(
                                'GO !',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            backgroundColor: Colors.amber,
                          ),
                          onPressed: _connecting ? null : () {login();},
                        ),
                      ),
                    ),
                )
              ],
            ),
        )
    );
  }
}
