import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';

class CircleButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;

  static const size = 150.0;

  const CircleButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: SciensaColors.red,
          borderRadius: BorderRadius.circular(75),
        ),
        child: const Text(
          'START',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
