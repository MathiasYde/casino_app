import 'package:casino_app/main.dart';
import "package:flutter/material.dart";

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: const Center(
        child: Text("LOGIN PAGE"),
      ),
    );
  }
}
