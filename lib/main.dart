import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FangApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoadingAppPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoadingAppPage extends StatefulWidget {
  LoadingAppPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoadingAppPageState createState() => _LoadingAppPageState();
}

class _LoadingAppPageState extends State<LoadingAppPage> {
  FirebaseUser _user;

  void _checkUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    Future.delayed(const Duration(seconds: 1), () => manageUserStatus(user));
  }

  void manageUserStatus(user)  {
    setState(() { _user = user; });
    Future.delayed(const Duration(seconds: 1), () => {
      if (user != null) {

      } else {

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/src/assets/fangapp-logo.png',
                      height: 300,
                      width: 300,
                    ),
                  ],
                ),
              ),
              Positioned(
                  bottom: 70,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(_user != null ? Colors.yellow : Colors.blue), backgroundColor: Colors.black)
                  )
              )
            ],
          )
      ),
    );
  }
}
