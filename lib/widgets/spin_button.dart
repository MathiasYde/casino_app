import 'package:flutter/material.dart';

class SpinButton extends StatelessWidget {
  const SpinButton({Key? key, required this.onPressed}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed as void Function()?,
      child: const Text("Spin!!!"),
    );
  }
}
