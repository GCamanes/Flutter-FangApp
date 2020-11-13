import 'package:fangapp/src/components/customTextField.dart';
import 'package:flutter/material.dart';

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
  String _connectingError;

  @override
  void initState() {
    super.initState();

    _mailNode = FocusNode();
    _passwordNode = FocusNode();
  }

  @override
  void dispose() {
    _mailNode.dispose();
    _passwordNode.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login() {
    setState(() {
      _connecting = !_connecting;
    });
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
                              inputAction: TextInputAction.go,
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
                Positioned(
                    bottom: size.height * 0.25,
                    right: 0,
                    left: 0,
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
                    )
                )
              ],
            ),
        )
    );
  }
}
