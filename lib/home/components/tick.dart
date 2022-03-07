import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';
import 'package:test_sciensa/helpers/sciensa_radius.dart';

class Tick extends StatefulWidget {
  const Tick({Key? key}) : super(key: key);

  static const tickSize = Size(8, 30);

  @override
  State<Tick> createState() => _TickState();
}

class _TickState extends State<Tick> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Tick.tickSize.width,
        height: Tick.tickSize.height,
        decoration: BoxDecoration(
          color: SciensaColors.gray1,
          borderRadius: BorderRadius.circular(SciensaRadius.small),
        ),
      ),
    );
  }
}
