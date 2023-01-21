import 'package:casino_app/pages/error_page.dart';
import 'package:casino_app/pages/home_page.dart';
import 'package:casino_app/pages/login_page.dart';
import 'package:casino_app/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(firebaseUserProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Casino App",
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: user.when(
        data: (data) => (data == null) ? const LoginPage() : const HomePage(),
        error: (error, stackTrace) => ErrorPage(error: error),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
