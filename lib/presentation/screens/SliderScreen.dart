import 'package:flutter/material.dart';
import 'package:new_app/core/api/PokeApi.dart';
import 'package:new_app/core/utils/ToastHelper.dart';
import 'package:toastification/toastification.dart';

class Sliderscreen extends StatefulWidget {
  const Sliderscreen({super.key});

  @override
  State<Sliderscreen> createState() => _SliderscreenState();
}

class _SliderscreenState extends State<Sliderscreen>
    with SingleTickerProviderStateMixin {
  String a = "";
  bool loading = true;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double sliderValue = 50;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getDitto() async {
    setState(() {
      loading = true;
    });
    try {
      Map<String, dynamic> mp = await PokeApi.fetchSinglePokemon("ditto");
      setState(() {
        a = mp["sprites"]["other"]["showdown"]["front_default"];
      });
    } catch (e) {
      print(e.toString());
      showToast(
        context: context,
        toastType: ToastificationType.error,
        title: "Ditto escaped",
        description: "Use a stronger pokeball next time",
      );
    } finally {
      loading = false;
    }
  }

  void onChanged(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(4.0),
            child: SlideTransition(
              position: _offsetAnimation,
              child: Image.network(
                "https://media.tenor.com/HMpkCtUVWY4AAAAi/pokemon-pokemems.gif",
                scale: 1,
              ),
            ),
          ),
          Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Slider(
                  year2023: false,
                  value: sliderValue,
                  onChanged: onChanged,
                  divisions: 6,
                  min: 0,
                  max: 100,
                  secondaryTrackValue: 0.8,
                ),
                SizedBox(height: 40),
                Slider.adaptive(
                  value: sliderValue,
                  onChanged: onChanged,
                  min: 0,
                  max: 100,
                  year2023: false,
                ),
                SizedBox(height: 40),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                    overlayColor: Theme.of(context).cardColor,
                  ),
                  child: Slider(
                    value: sliderValue,
                    year2023: false,
                    min: 0,
                    max: 100,
                    onChanged: onChanged,
                    divisions: 100,
                    label: sliderValue.toStringAsFixed(0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('0'), Text('50'), Text('100')],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
