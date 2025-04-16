import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/presentation/widgets/CardWidget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boxes = Hive.box('favouritesBox');
    final favourites = boxes.toMap();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left),
          iconSize: 30,
          color: Colors.white,
        ),
        title: Text(
          "Favourites",
          style: GoogleFonts.righteous(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          favourites.isNotEmpty
              ? GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.67,
                ),
                itemCount: favourites.length,
                itemBuilder: (context, i) {
                  final index = favourites.keys.elementAt(i);
                  final data = favourites[index];
                  return CardWidget(
                    name: data["name"],
                    color: getColorForType(data["types"][0]["type"]["name"]),
                    imageUrl:
                        data["sprites"]["other"]["official-artwork"]["front_default"],
                    number: data["id"],
                    type: data["types"][0]["type"]["name"],
                    hp: data["stats"][0]["base_stat"],
                    labels: ["Attack", "Defence", "Speed"],
                    values: [
                      data["stats"][1]["base_stat"].toString(),
                      data["stats"][2]["base_stat"].toString(),
                      data["stats"][5]["base_stat"].toString(),
                    ],
                    allData: data,
                  );
                },
              )
              : Center(child: Text("No favorites chosen yet")),
    );
  }
}
