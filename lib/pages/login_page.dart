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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text("Sign in page", style: TextStyle(fontSize: 48)),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Enter email"),
                    validator: ValidationBuilder().email().build(),
                    controller: emailController,
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Enter password"),
                    validator:
                        ValidationBuilder().minLength(6).maxLength(27).build(),
                    controller: passwordController,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ElevatedButton(
                onPressed: () async {
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
                },
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
                child: const Text("Don't have an account?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
