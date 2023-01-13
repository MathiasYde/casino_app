import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      setState(() {
        _initialized = true;
      });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _initialized
              ? Text('Firebase connection established')
              : _error
                  ? Text('Error connecting to Firebase')
                  : Text('Initializing...'),
        ),
      ),
    );
  }
}
