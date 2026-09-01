import 'package:flutter/material.dart';

/// Thin horizontal dashed line used to separate the score block from the
/// status row on a live match card.
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key, this.color = Colors.white24, this.height = 1});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: dashSpace),
              child: Container(width: dashWidth, height: height, color: color),
            );
          }),
        );
      },
    );
  }
}
