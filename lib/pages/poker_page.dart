import 'package:flutter/material.dart';

class PokerPage extends StatelessWidget {
  const PokerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("poker"),
      ),
      body: const Center(
        child: Text("POKER"),
      ),
    );
  }
}
