import 'package:flutter/material.dart';
import 'package:new_app/presentation/widgets/Tabs.dart';

class Colm2 extends StatelessWidget {
  final tabBarColor;
  final allData;
  const Colm2({super.key, required this.tabBarColor, required this.allData});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TabbedLayout(TabColor: tabBarColor, allData: allData),
            ),
          ],
        ),
      ),
    );
  }
}
