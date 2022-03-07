import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';
import 'package:test_sciensa/helpers/sciensa_radius.dart';
import 'package:test_sciensa/helpers/text_extension.dart';

class CircleButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  static const size = 150.0;

  const CircleButton({Key? key, required this.label, required this.onPressed})
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
          borderRadius: BorderRadius.circular(SciensaRadius.circle),
        ),
        child: Text(label).button(),
      ),
    );
  }
}
