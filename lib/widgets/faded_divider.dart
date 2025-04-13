import 'package:flutter/material.dart';

class FadedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final double fadeWidth;

  const FadedDivider({
    Key? key,
    this.height = 1,
    this.thickness = 1,
    this.color = Colors.grey,
    this.fadeWidth = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback:
          (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, color, color, Colors.transparent],
            stops: [
              0.0,
              fadeWidth / bounds.width,
              1 - (fadeWidth / bounds.width),
              1.0,
            ],
          ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: Container(height: height, color: color),
    );
  }
}
