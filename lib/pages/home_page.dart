import 'package:casino_app/widgets/casino_kidz_appbar.dart';
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
    Widget buildGameEntry(
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
        appBar: const CasinoKidzAppBar(),
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
                    buildGameEntry(
                      "Poker",
                      "assets/images/poker.png",
                      const PokerPage(),
                      false,
                    ),
                    buildGameEntry(
                      "Roulette",
                      "assets/images/roulette.png",
                      const RoulettePage(),
                      false,
                    ),
                    buildGameEntry(
                      "Blackjack",
                      "assets/images/blackjack.png",
                      const BlackjackPage(),
                      false,
                    ),
                    buildGameEntry(
                      "Slotmachine",
                      "assets/images/slotmachine.png",
                      const SlotmachinePage(),
                      true,
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
