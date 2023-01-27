import 'package:casino_app/datamodels/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class CasinoKidzAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CasinoKidzAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userProvider).value ?? const User();

    return AppBar(
      title: Column(
        children: [
          Text(
            "Balance:",
            style: GoogleFonts.blackHanSans(),
          ),
          Text(
            "${user.balance}",
            style: GoogleFonts.blackHanSans(),
          )
        ],
      ),
      actions: [
        (Navigator.of(context).canPop())
            ? TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "<- Back",
                  style: GoogleFonts.blackHanSans(
                      color: Colors.white, fontSize: 18),
                ),
              )
            : TextButton(
                onPressed: () {
                  firebase_auth.FirebaseAuth.instance.signOut();
                },
                child: Text(
                  "Log Out",
                  style: GoogleFonts.blackHanSans(
                      color: Colors.white, fontSize: 18),
                ),
              ),
      ],
      leading: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Image.asset("assets/images/logo.png")),
      backgroundColor: const Color.fromARGB(100, 0, 0, 0),
      shadowColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
