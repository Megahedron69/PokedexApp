import 'package:flutter/material.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/SvgUrlHelper.dart';

class Colm1 extends StatelessWidget {
  final String number, name, imageURL;
  final List<dynamic> types;

  const Colm1({
    super.key,
    required this.number,
    required this.name,
    required this.imageURL,
    required this.types,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        Text(
          "#00$number",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 32,
            height: 1,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          name.capitalize(),
          textAlign: TextAlign.left,
          softWrap: false,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children:
              types.map<Widget>((type) {
                final String typeName = type["type"]["name"];
                return Chip(
                  label: Text(
                    typeName.capitalize(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  elevation: 20,
                  avatar: getTypeIcon(typeName),
                  backgroundColor: getColorForType(typeName),
                );
              }).toList(),
        ),
      ],
    );
  }
}
