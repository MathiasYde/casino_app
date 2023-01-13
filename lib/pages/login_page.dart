import 'package:casino_app/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String _errorCode = "";
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  Future<void> _checkLogin({email, password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        setState(() {
          _errorCode = "No user found for that email";
        });
      } else if (e.code == "wrong-password") {
        setState(() {
          _errorCode = "Wrong password or email";
        });
      } else {
        setState(() {
          _errorCode = "there was an error";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              InputText(
                title: "E-mail:",
                textFieldController: _emailController,
              ),
              const SizedBox(
                height: 25,
              ),
              InputText(
                title: "Password:",
                hideText: true,
                textFieldController: _passwordController,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(_errorCode),
              TextButton(
                  onPressed: (() => _checkLogin(
                      email: _emailController.text,
                      password: _passwordController.text)),
                  child: const Text("Login")),
              TextButton(
                  onPressed: (() => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const SignupPage())))),
                  child: const Text("Sign up")),
            ],
          ),
        ));
  }
}

class InputText extends StatelessWidget {
  const InputText(
      {super.key,
      required this.title,
      this.hideText = false,
      required this.textFieldController});

  final String title;
  final bool hideText;
  final TextEditingController textFieldController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        TextField(
          controller: textFieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusColor: Colors.black,
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          obscureText: hideText,
        ),
      ],
    );
  }
}
