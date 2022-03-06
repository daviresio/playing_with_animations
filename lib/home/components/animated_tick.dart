import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/math_helper.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';

class AnimatedTick extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedTick({Key? key, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: AnimatedBuilder(
          animation: animation,
          builder: (_, __) {
            final width =
                MathHelper.remap(animation.value, 0, 1, 0, screenSize.width);
            final height =
                MathHelper.remap(animation.value, 0, 1, 0, screenSize.height);

            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: SciensaColors.red,
                borderRadius: BorderRadius.circular(5.0),
              ),
            );
          }),
    );
  }
}
