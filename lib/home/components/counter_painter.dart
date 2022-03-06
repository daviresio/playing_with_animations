import 'package:flutter/material.dart';
import 'package:test_sciensa/helpers/math_helper.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';

class CounterPainter extends CustomPainter {
  final int seconds;
  final Animation<double> scaleAnimation;
  final Animation<double> cronAnimation;

  CounterPainter({
    required this.seconds,
    required this.scaleAnimation,
    required this.cronAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SciensaColors.red
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    final heightBySeconds =
        MathHelper.remap(seconds.toDouble(), 0, 30, 0, size.height);

    final fullWidth =
        MathHelper.remap(scaleAnimation.value, 0, 1, 4, size.width);
    final fullHeight =
        MathHelper.remap(scaleAnimation.value, 0, 1, 30, size.height);

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - fullWidth / 2,
        heightBySeconds == 0
            ? center.dy - fullHeight / 2
            : size.height - heightBySeconds,
        fullWidth,
        fullHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
