import 'package:casino_app/pages/home_page.dart';
import 'package:casino_app/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late bool _showPassword;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup Page"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Text("Sign up", style: TextStyle(fontSize: 48)),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Enter username"),
                  validator:
                      ValidationBuilder().minLength(3).maxLength(27).build(),
                  controller: usernameController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Enter email"),
                  validator: ValidationBuilder().email().build(),
                  controller: emailController,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    suffixIcon: IconButton(
                        onPressed: (() => setState(() {
                              _showPassword = !_showPassword;
                            })),
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off)),
                  ),
                  validator:
                      ValidationBuilder().minLength(6).maxLength(27).build(),
                  controller: passwordController,
                  obscureText: _showPassword,
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final username = usernameController.text;
                final email = emailController.text;
                final password = passwordController.text;

                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // create user in firestore
                  final userData = <String, dynamic>{
                    "username": username,
                    "balance": 0
                  };

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(credential.user!.uid)
                      .set(userData);

                  // redirect to home page
                  // TODO(mathias): could this fail and then the user is stuck on the signup page?
                  if (!mounted) return;

                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const HomePage();
                    }),
                  );
                } on FirebaseAuthException catch (e) {
                  SnackBar snackBar = SnackBar(content: Text("${e.message}"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (e) {
                  SnackBar snackBar = SnackBar(content: Text("$e"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text("Sign up"),
            ),
            TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              child: const Text("Already have an account?"),
            )
          ]),
        ),
      ),
    );
  }
}
