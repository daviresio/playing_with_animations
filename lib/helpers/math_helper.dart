class MathHelper {
  static double remap(
    double value,
    double start1,
    double stop1,
    double start2,
    double stop2,
  ) {
    final outgoing =
        start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1));

    return outgoing;
  }
}
