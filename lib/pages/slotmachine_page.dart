import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SlotmachinePage extends StatefulWidget {
  const SlotmachinePage({Key? key}) : super(key: key);

  @override
  State<SlotmachinePage> createState() => SlotmachinePageState();
}

class SlotmachinePageState extends State<SlotmachinePage>
    with SingleTickerProviderStateMixin {
  final int _slotsCount = 3;

  List<String> iconFilepaths = [
    "assets/images/slotmachine/banana.png",
    "assets/images/slotmachine/cherry.png",
    "assets/images/slotmachine/dollar.png",
    "assets/images/slotmachine/moon.png",
    "assets/images/slotmachine/seven.png",
    "assets/images/slotmachine/star.png",
    "assets/images/slotmachine/sun.png",
    "assets/images/slotmachine/watermelon.png",
  ];

  late List<Widget> items;

  late List<int> _selectedItemIndicies;

  late List<GlobalKey> _reelKeys;

  @override
  void initState() {
    super.initState();
    _selectedItemIndicies = List.generate(_slotsCount, (index) => 0);

    items = List.generate(
        iconFilepaths.length,
        (index) => Image(
              image: AssetImage(iconFilepaths[index]),
            ));

    _reelKeys = List.generate(
        _slotsCount, (index) => GlobalKey<SlotMachineReelState>());
  }

  int getRandomTime(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }

  void spin() async {
    for (GlobalKey reelKey in _reelKeys) {
      SlotMachineReelState reelState =
          reelKey.currentState as SlotMachineReelState;
      reelState.startSpin();
    }

    await Future.delayed(Duration(milliseconds: getRandomTime(400, 1200)));

    for (GlobalKey reelKey in _reelKeys) {
      SlotMachineReelState reelState =
          reelKey.currentState as SlotMachineReelState;

      await Future.delayed(Duration(milliseconds: getRandomTime(600, 1700)));

      reelState.stopSpin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slotmachine Page"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _slotsCount; i++)
                Expanded(
                  child: Container(
                      height: 200,
                      child: SlotMachineReel(
                        key: _reelKeys[i],
                        reelItems: items,
                        offAxisFraction: i / _slotsCount - 0.5,
                      )),
                ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          ElevatedButton(
            onPressed: spin,
            child: const Text("Spin"),
          ),
        ],
      ),
    );
  }
}

class SlotMachineReel extends StatefulWidget {
  const SlotMachineReel({
    Key? key,
    required this.reelItems,
    this.offAxisFraction = 0.0,
  }) : super(key: key);

  final List<Widget> reelItems;
  final double offAxisFraction;

  @override
  State<SlotMachineReel> createState() => SlotMachineReelState();
}

class SlotMachineReelState extends State<SlotMachineReel>
    with SingleTickerProviderStateMixin {
  late FixedExtentScrollController _scrollController;

  late Timer spinTimer;
  late int counter;
  final Duration continousSpinDuration = const Duration(milliseconds: 50);

  void startSpin() {
    counter = 0;
    spinTimer = Timer.periodic(continousSpinDuration, (timer) {
      _scrollController.animateToItem(
        counter,
        duration: continousSpinDuration,
        curve: Curves.linear,
      );
      counter--;
    });
  }

  void stopSpin() {
    spinTimer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      offAxisFraction: widget.offAxisFraction,
      controller: _scrollController,
      itemExtent: 100,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildLoopingListDelegate(
        children: widget.reelItems,
      ),
    );
  }
}
