import 'package:flutter/material.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/Extensions.dart';
import '../widgets/AboutPokeColumn1.dart';
import '../widgets/AboutPokeColm2.dart';

class Detailscreen extends StatelessWidget {
  final String name;
  final Map<String, dynamic> allData;

  const Detailscreen({super.key, required this.name, required this.allData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorForType(
          allData['types'][0]['type']['name'],
        ).withAlpha(90),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left),
          iconSize: 36,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () => debugPrint("Hellz"),
            icon: const Icon(Icons.favorite),
            iconSize: 36,
            color: Colors.white,
          ),
        ],
        centerTitle: true,
        title: Text(
          name.capitalize(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: getColorForType(
          allData['types'][0]['type']['name'],
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
                      number: allData["id"].toString(),
                      name: allData["name"],
                      imageURL:
                          allData["sprites"]["other"]["official-artwork"]["front_default"],
                      types: allData["types"],
                    ),
                  ),
                  Image.network(
                    allData["sprites"]["other"]["official-artwork"]["front_default"],
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
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 50);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Colm2(
                  tabBarColor: getColorForType(
                    allData['types'][0]['type']['name'],
                  ).withAlpha(90),
                  allData: allData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
