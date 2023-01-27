import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:casino_app/datamodels/user.dart';

import 'package:casino_app/pages/blackjack_page.dart';
import 'package:casino_app/pages/poker_page.dart';
import 'package:casino_app/pages/roulette_page.dart';
import 'package:casino_app/pages/slotmachine_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userProvider).value ?? const User();

    // function generator since this is not a reuseable widget
    Widget _buildGameEntry(
        String title, String filepath, Widget page, bool enabled) {
      return TextButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: ((context) => page))),
        child: SizedBox(
          width: 150,
          child: Column(
            children: [
              Image.asset(
                filepath,
                width: 100,
              ),
              Text(
                title,
                style: GoogleFonts.blackHanSans(
                  color: enabled ? Colors.white : Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          leading: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Image.asset("assets/images/logo.png")),
          backgroundColor: const Color.fromARGB(100, 0, 0, 0),
          shadowColor: Colors.transparent,
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
            TextButton(
              onPressed: () {
                firebase_auth.FirebaseAuth.instance.signOut();
              },
              child: Text(
                "Log Out",
                style:
                    GoogleFonts.blackHanSans(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Most popular games",
                style: GoogleFonts.blackHanSans(fontSize: 32),
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  children: [
                    _buildGameEntry("Poker", "assets/images/poker.png",
                        const PokerPage(), false),
                    _buildGameEntry("Roulette", "assets/images/roulette.png",
                        const RoulettePage(), false),
                    _buildGameEntry("Blackjack", "assets/images/blackjack.png",
                        const BlackjackPage(), false),
                    _buildGameEntry(
                        "Slotmachine",
                        "assets/images/slotmachine.png",
                        const SlotmachinePage(),
                        true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
