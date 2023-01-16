import 'package:flutter/material.dart';

class BlackjackPage extends StatelessWidget {
  const BlackjackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blackjack"),
      ),
      body: const Center(
        child: Text("BLACKJACK"),
      ),
    );
  }
}
