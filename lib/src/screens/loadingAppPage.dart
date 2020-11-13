import 'package:fangapp/src/screens/loginPage.dart';
import 'package:fangapp/src/screens/mangasListPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingAppPage extends StatefulWidget {
  LoadingAppPage({Key key}) : super(key: key);

  @override
  _LoadingAppPageState createState() => _LoadingAppPageState();
}

class _LoadingAppPageState extends State<LoadingAppPage> {
  FirebaseUser _user;

  void _checkUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    final FirebaseUser user = await auth.currentUser();
    Future.delayed(const Duration(seconds: 1), () => manageUserStatus(user));
  }

  void manageUserStatus(user)  {
    setState(() { _user = user; });
    Future.delayed(const Duration(seconds: 1), () => {
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MangasListPage()),
          (route) => false,
        )
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        )
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Center(
                 child: Image.asset(
                    'lib/src/assets/fangapp-logo.png',
                    height: 300,
                    width: 300,
                  ),
              ),
              Positioned(
                  bottom: 70,
                  right: 0,
                  left: 0,
                  child: Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_user != null ? Colors.amber : Colors.blue), backgroundColor: Colors.black)
                  )
              )
            ],
          )
      ),
    );
  }
}
