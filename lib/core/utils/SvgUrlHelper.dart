import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

Widget getTypeIcon(String type, {double size = 20}) {
  return SvgPicture.asset(
    'assets/images/poke-types/$type.svg',
    width: size,
    height: size,
    placeholderBuilder: (context) => Icon(Icons.error, size: size),
  );
}
