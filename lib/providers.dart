import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseUserProvider = StreamProvider.autoDispose<firebase_auth.User?>(
  (ref) => firebase_auth.FirebaseAuth.instance.authStateChanges(),
);
