import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/presentation/widgets/ListViewBuildWidget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              debugPrint("Search");
            },
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: Icon(Icons.favorite),
            onPressed: () {
              debugPrint("Search");
            },
          ),
        ],
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Image.asset('assets/images/pokeball.png', width: 30, height: 30),
            Text(
              "Pokédex",
              style: GoogleFonts.righteous(
                textStyle: Theme.of(context).textTheme.headlineMedium,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: ListViewBuildWidget(),
      extendBodyBehindAppBar: true, // ✅ Key to allow content under status bar
    );
  }
}
