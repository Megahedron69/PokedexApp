import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/presentation/widgets/GradientTextWidget.dart';

class PokeBattleScreen extends StatefulWidget {
  const PokeBattleScreen({Key? key}) : super(key: key);

  @override
  _PokeBattleScreenState createState() => _PokeBattleScreenState();
}

class _PokeBattleScreenState extends State<PokeBattleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: context.sw - 600,
          top: context.sh - 800,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.1416,
                child: child,
              );
            },
            child: Transform.rotate(
              angle: -0.5,
              child: Opacity(
                opacity: 0.09,
                child: SvgPicture.asset(
                  'assets/images/pokeballz.svg',
                  width: context.sw * 1.2,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.8),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        BoxesWidget(),
      ],
    );
  }
}

class BoxesWidget extends StatelessWidget {
  const BoxesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8, // Bound the height
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top row with two small boxes on left and one tall box on right
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // Left column with two square cards
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // Water type
                        Expanded(
                          child: GradientCard(
                            title: 'Sliders',
                            colors: [Color(0xFF5EBDFC), Color(0xFF2E78C8)],
                            textColor: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
                          ),
                        ),
                        // Fire type
                        Expanded(
                          child: GradientCard(
                            title: 'Bluetooth',
                            colors: [Color(0xFFFFA756), Color(0xFFFF5252)],
                            textColor: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Grass type
                  Expanded(
                    flex: 1,
                    child: GradientCard(
                      title: 'Radios',
                      colors: [Color(0xFF8CD851), Color(0xFF1F6E5C)],
                      textColor: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                    ),
                  ),
                ],
              ),
            ),
            // Psychic type
            Expanded(
              flex: 1,
              child: GradientCard(
                title: 'Animations',
                colors: [Color(0xFFFF9DE2), Color(0xFFE469D5)],
                textColor: [Colors.black54, Colors.pinkAccent],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final List<Color> textColor;

  const GradientCard({
    super.key,
    required this.title,
    required this.colors,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 8.0,
        shadowColor: Colors.black.withAlpha(50),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
              ),
            ),
            // Material + InkWell on top
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: colors[0].withValues(alpha: 0.3),
                highlightColor: Colors.transparent,
                borderRadius: BorderRadius.circular(24.0),
                onTap: () {
                  debugPrint("Card tapped: $title");
                  context.go('/${title.trim().toLowerCase()}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.ac_unit_outlined, color: colors[1]),
                          Icon(Icons.access_time, color: colors[1]),
                        ],
                      ),
                      GradientText(text: title, colors: textColor, size: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(
                          thickness: 1.2,
                          indent: 5.0,
                          color: colors[0].withAlpha(103),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
