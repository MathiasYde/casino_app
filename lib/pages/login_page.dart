import 'package:casino_app/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:form_validator/form_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late bool _showPassword;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showPassword = true;
  }

  void _signin() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      SnackBar snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text("$e"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.yellow],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Sign in page"),
          backgroundColor: const Color.fromARGB(100, 0, 0, 0),
          shadowColor: Colors.transparent,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Sign in", style: TextStyle(fontSize: 48)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Enter email",
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      validator: ValidationBuilder().email().build(),
                      controller: emailController,
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        filled: true,
                        fillColor: Colors.grey,
                        suffixIcon: IconButton(
                            onPressed: (() => setState(() {
                                  _showPassword = !_showPassword;
                                })),
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                      validator: ValidationBuilder()
                          .minLength(6)
                          .maxLength(27)
                          .build(),
                      controller: passwordController,
                      obscureText: _showPassword,
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                ElevatedButton(
                  onPressed: (() => _signin()),
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignupPage();
                    }));
                  },
                  child: const Text(
                    "Don't have an account?",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
