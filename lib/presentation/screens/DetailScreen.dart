import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/Extensions.dart';
import '../widgets/AboutPokeColumn1.dart';
import '../widgets/AboutPokeColm2.dart';

class Detailscreen extends StatefulWidget {
  final String name;
  final Map<String, dynamic> allData;
  const Detailscreen({super.key, required this.name, required this.allData});
  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen>
    with SingleTickerProviderStateMixin {
  late Box boxes;
  late bool isRed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    boxes = Hive.box('favouritesBox');
    isRed = boxes.containsKey(widget.allData["name"]);
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorForType(
          widget.allData['types'][0]['type']['name'],
        ).withAlpha(90),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                final key = widget.allData["name"];
                if (isRed) {
                  boxes.delete(key);
                } else {
                  boxes.put(widget.name, widget.allData);
                }
                isRed = !isRed;
                isRed ? _controller.reverse() : _controller.forward();
              });
            },
            icon: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    Icons.favorite,
                    size: 30,
                    color: isRed ? Colors.red : Colors.white,
                  ),
                );
              },
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.name.capitalize(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: getColorForType(
          widget.allData['types'][0]['type']['name'],
        ).withAlpha(90),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Colm1(
                      number: widget.allData["id"].toString(),
                      name: widget.allData["name"],
                      imageURL:
                          widget
                              .allData["sprites"]["other"]["official-artwork"]["front_default"],
                      types: widget.allData["types"],
                    ),
                  ),
                  Hero(
                    tag: widget.allData["name"],
                    child: Image.network(
                      widget
                          .allData["sprites"]["other"]["official-artwork"]["front_default"],
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value:
                                loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 50);
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Colm2(
                  tabBarColor: getColorForType(
                    widget.allData['types'][0]['type']['name'],
                  ).withAlpha(90),
                  allData: widget.allData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
