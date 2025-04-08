import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:new_app/core/api/PokeApi.dart";
import "package:new_app/core/utils/ColorHelper.dart";
import "package:new_app/presentation/widgets/CardWidget.dart";
import "package:new_app/providers/pokemon.providers.dart";

class ListViewBuildWidget extends StatefulWidget {
  const ListViewBuildWidget({super.key});

  @override
  _ListViewBuildWidgetState createState() => _ListViewBuildWidgetState();
}

class _ListViewBuildWidgetState extends State<ListViewBuildWidget> {
  List<dynamic> pokemonList = [], details = [];
  late Future<void> _pokemonDataFuture;
  bool loading = true;
  String? error;
  Future<void> getMyPokemonData() async {
    try {
      setState(() {
        loading = true;
      });
      pokemonList = await PokeApi.fetchMyPokemon(limit: 10, apiName: "pokemon");
      for (var item in pokemonList) {
        var detail = await PokeApi.fetchMyPokemon(
          limit: 1,
          apiName: "pokemon",
          pokemonName: item["name"],
        );
        details.add(detail[0]);
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        debugPrint("error occurred $e");
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    _pokemonDataFuture = getMyPokemonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pokemonDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.67,
                ),
                itemCount: pokemonList.length,
                itemBuilder: (context, index) {
                  final pokemon = details[index];
                  return CardWidget(
                    name: pokemon["name"],
                    color: getColorForType(pokemon["types"][0]["type"]["name"]),
                    imageUrl:
                        pokemon["sprites"]["other"]["official-artwork"]["front_default"],
                    number: pokemon["id"],
                    type: pokemon["types"][0]["type"]["name"],
                    hp: pokemon["stats"][0]["base_stat"],
                    labels: ["Attack", "Defence", "Speed"],
                    values: [
                      pokemon["stats"][1]["base_stat"].toString(),
                      pokemon["stats"][2]["base_stat"].toString(),
                      pokemon["stats"][5]["base_stat"].toString(),
                    ],
                    allData: pokemon,
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
