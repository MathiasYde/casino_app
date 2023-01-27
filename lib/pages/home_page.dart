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
                  children: const [
                    GameEntry(
                      photo: "poker.png",
                      title: "Poker",
                      page: PokerPage(),
                    ),
                    GameEntry(
                        photo: "roulette.png",
                        title: "Roulette",
                        page: RoulettePage()),
                    GameEntry(
                      photo: "blackjack.png",
                      title: "Blackjack",
                      page: BlackjackPage(),
                      activ: false,
                    ),
                    GameEntry(
                      photo: "slotmachine.png",
                      title: "Slotmachine",
                      page: SlotmachinePage(),
                      activ: false,
                    ),
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

class GameEntry extends StatelessWidget {
  final bool isTrue = true;
  const GameEntry({
    super.key,
    required this.photo,
    required this.title,
    required this.page,
    this.activ = true,
  });

  final String photo;
  final String title;
  final Widget page;
  final bool activ;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: ((context) => page))),
      child: SizedBox(
        width: 150,
        child: Column(
          children: [
            Image.asset(
              "assets/images/$photo",
              width: 100,
            ),
            Text(
              title,
              style: GoogleFonts.blackHanSans(
                color: activ ? Colors.white : Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
