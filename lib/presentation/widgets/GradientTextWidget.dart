import "package:flutter/material.dart";

class GradientText extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final double size;

  const GradientText({
    super.key,
    required this.text,
    required this.colors,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.6],
          tileMode: TileMode.clamp,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
  }
}
