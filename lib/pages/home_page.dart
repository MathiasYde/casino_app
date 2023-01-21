import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
    var user = ref.watch(userProvider).value!;

    Widget buildGamePageEntry(String title, Widget page, Widget? thumbnail,
        {bool enabled = true}) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: thumbnail ??
            Container(
              color: enabled ? Colors.red : Colors.grey,
              child: Text(title),
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.username}"),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("${user.balance}"),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
          const Text("Most popular games", style: TextStyle(fontSize: 32.0)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0),
              children: [
                buildGamePageEntry(
                    "Slotmachine", const SlotmachinePage(), null),
                buildGamePageEntry("Roulette", const RoulettePage(), null),
                buildGamePageEntry("Blackjack", const BlackjackPage(), null,
                    enabled: false),
                buildGamePageEntry("Poker", const PokerPage(), null,
                    enabled: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
