import 'dart:async';
import 'dart:math';

import 'package:casino_app/datamodels/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SlotmachinePage extends StatefulWidget {
  const SlotmachinePage({Key? key}) : super(key: key);

  @override
  State<SlotmachinePage> createState() => SlotmachinePageState();
}

class SlotmachinePageState extends State<SlotmachinePage>
    with SingleTickerProviderStateMixin {
  final int _slotsCount = 4;

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
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _selectedItemIndicies = List.generate(_slotsCount, (index) => 0);

    items = List.generate(
        iconFilepaths.length,
        (index) => Image(
              image: AssetImage(iconFilepaths[index]),
              width: 75,
            ));

    _reelKeys = List.generate(
        _slotsCount, (index) => GlobalKey<SlotMachineReelState>());
  }

  int getRandomTime(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }

  void spin() async {
    if (_isSpinning) return;
    _isSpinning = true;

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

    _isSpinning = false;
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      return Colors.green;
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
        appBar: const AppBarV2(),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: Text(
                "Slot Machine",
                style: GoogleFonts.blackHanSans(fontSize: 40),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _slotsCount; i++)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      height: 200,
                      child: Stack(
                        children: [
                          SlotMachineReel(
                            key: _reelKeys[i],
                            reelItems: items,
                            offAxisFraction: i / _slotsCount - 0.5,
                          ),
                          ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcOut,
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    backgroundBlendMode: BlendMode.dstOut,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    height: 175,
                                    width: 75,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
            ElevatedButton(
              onPressed: spin,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(getColor),
              ),
              child: Text(
                "Spin",
                style: GoogleFonts.lobster(fontSize: 69),
              ),
            ),
          ],
        ),
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

class AppBarV2 extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarV2({super.key});

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
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "<- Back",
            style: GoogleFonts.blackHanSans(color: Colors.white, fontSize: 18),
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

class SlotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    /* Offset offset = Offset(size.width / 2, size.height / 2);
    Rect rect =
        Rect.fromCenter(center: offset, width: size.width, height: size.height);

    canvas.drawRect(rect, paint); */
  }

  @override
  bool shouldRepaint(SlotPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SlotPainter oldDelegate) => false;
}
