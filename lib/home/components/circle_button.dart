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
    return ClipRRect(
      borderRadius: BorderRadius.circular(SciensaRadius.circle),
      child: Material(
        color: SciensaColors.red,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(SciensaRadius.circle),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Text(label).button(),
          ),
        ),
      ),
    );
  }
}
