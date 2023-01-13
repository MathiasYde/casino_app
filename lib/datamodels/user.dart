import 'package:casino_app/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part "user.freezed.dart";
part "user.g.dart";

// build configuration files with: flutter pub run build_runner build

@freezed
class User with _$User {
  const factory User({
    required String username,
    required int balance,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}

final userProvider = StreamProvider<User?>((ref) {
  final firebaseUser = ref.watch(firebaseUserProvider).value;

  if (firebaseUser == null) {
    return const Stream.empty();
  }

  var document =
      FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid);
  return document.snapshots().map((snapshot) {
    return User.fromJson(snapshot.data()!);
  });
});
