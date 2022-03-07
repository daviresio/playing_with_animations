import 'package:flutter/widgets.dart';
import 'package:test_sciensa/helpers/sciensa_colors.dart';

extension TextExtension on Text {
  Text title() {
    return Text(
      data!,
      style: TextStyle(
          color: SciensaColors.white,
          fontSize: 70,
          fontWeight: FontWeight.w500,
          shadows: [
            Shadow(
              color: SciensaColors.black.withOpacity(0.4),
              offset: Offset.zero,
              blurRadius: 6,
            ),
          ]),
    );
  }

  Text subtitle() {
    return Text(
      data!,
      style: const TextStyle(color: SciensaColors.gray2, fontSize: 20),
    );
  }

  Text button() {
    return Text(
      data!,
      style: const TextStyle(color: SciensaColors.white, fontSize: 30),
    );
  }
}
