import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/auth/auth_service.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/ToastHelper.dart';
import 'package:new_app/presentation/screens/PokeBattleScreen.dart';
import 'package:new_app/presentation/widgets/ListViewBuildWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/pokemon.providers.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  final NotchBottomBarController? controller;
  const HomeScreen({super.key, this.controller});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigBut() {
    if (!context.mounted) return;
    context.go("/details/Pikachu");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          widget.controller?.jumpTo(2);
        },
        child: ListViewBuildWidget(),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
