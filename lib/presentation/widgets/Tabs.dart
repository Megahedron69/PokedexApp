import 'package:flutter/material.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/presentation/widgets/AboutWidget.dart';
import 'package:new_app/presentation/widgets/BaseStatsWidget.dart';
import 'package:new_app/presentation/widgets/EvolutionWidget.dart';

class TabbedLayout extends StatelessWidget {
  final TabColor;
  final allData;
  const TabbedLayout({
    super.key,
    required this.TabColor,
    required this.allData,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TabColor, width: 2),
            ),
            child: TabBar(
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Base Stats'),
                Tab(text: 'Evolution'),
              ],
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.sw * 0.0385,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                color: TabColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                AboutWidget(),
                BaseStatsWidget(),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: EvolutionChainWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
