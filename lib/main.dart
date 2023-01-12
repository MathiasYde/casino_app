import 'package:casino_app/pages/error_page.dart';
import 'package:casino_app/pages/home_page.dart';
import 'package:casino_app/pages/login_page.dart';
import 'package:casino_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App());
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseUser = ref.watch(firebaseUserProvider);

    return MaterialApp(
      title: "Casino App",
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: firebaseUser.when(
        data: (user) {
          return (user == null) ? const LoginPage() : const HomePage();
        },
        error: (error, stack) => ErrorPage(error: error),
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
