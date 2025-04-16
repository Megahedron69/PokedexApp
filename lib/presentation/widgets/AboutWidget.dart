import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/core/api/PokeApi.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/SvgUrlHelper.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class AboutWidget extends ConsumerStatefulWidget {
  const AboutWidget({super.key});
  @override
  ConsumerState<AboutWidget> createState() => _AboutWidget();
}

class _AboutWidget extends ConsumerState<AboutWidget> {
  String? desc = "";
  String? error = "";
  bool loading = true;
  Map<String, dynamic> PokeSpeciesMap = {};
  Future<void> fetchDescription() async {
    try {
      final allData = ref.read(allDataProvider);
      final data = await PokeApi.fetchMyPokemon(
        apiName: "pokemon-species",
        pokemonName: allData["name"],
      );
      final data2 = await PokeApi.fetchMyPokemon(
        apiName: "type",
        pokemonName: "${allData["types"][0]["type"]["name"]}",
      );
      final weakness = data2[0]["damage_relations"]["double_damage_from"];
      final entry = (data[0]["flavor_text_entries"] as List).firstWhere(
        (e) => e["language"]["name"] == "en",
        orElse: () => null,
      );
      final species = data[0]["genera"][7]["genus"];
      final captureRate = data[0]["capture_rate"];
      final abilities = allData["abilities"];
      setState(() {
        PokeSpeciesMap.addAll({
          "description":
              entry != null
                  ? entry["flavor_text"]
                      .toString()
                      .replaceAll('\n', ' ')
                      .replaceAll('\f', ' ')
                  : "No English description found.",
          "species": species,
          "height": "${allData["height"]} ft",
          "weight": "${allData["weight"]} g",
          "captureRate": "$captureRate%",
          "abilities": abilities.map((a) => a["ability"]["name"]).join(", "),
          "weakness": weakness.map((a) => a["name"]).toList(),
        });

        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error: $e";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDescription();
  }

  @override
  Widget build(BuildContext context) {
    final pokeColor = ref.watch(pokeMonColorProvider);

    if (loading) {
      return Center(child: CircularProgressIndicator(color: pokeColor));
    } else if (error != "") {
      return Center(
        child: Text(error!, style: TextStyle(color: Colors.redAccent)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                PokeSpeciesMap["description"] ?? "",
                style: TextStyle(color: Colors.grey),
              ),

              Text(
                "Pokedex Data",
                style: TextStyle(
                  color: pokeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              PokedexData(pokeSpeciesMap: PokeSpeciesMap),
            ],
          ),
        ),
      );
    }
  }
}

class PokedexData extends StatelessWidget {
  final Map<String, dynamic>? pokeSpeciesMap;
  const PokedexData({super.key, required this.pokeSpeciesMap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            pokeSpeciesMap!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${_formatKey(entry.key)}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Value or special handling
                    Expanded(
                      flex: 3,
                      child:
                          entry.key == "weakness"
                              ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      (entry.value as List).map<Widget>((val) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: getColorForType(
                                              val,
                                            ),
                                            child: getTypeIcon(val),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              )
                              : entry.value is List
                              ? Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children:
                                    (entry.value as List).map<Widget>((val) {
                                      return Chip(
                                        label: Text(
                                          val is Map
                                              ? val["name"] ?? val.toString()
                                              : val.toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      );
                                    }).toList(),
                              )
                              : Text(
                                entry.value.toString(),
                                style: TextStyle(color: Colors.grey),
                              ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

String _formatKey(String key) {
  return key
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => "${match[1]} ${match[2]}",
      )
      .capitalize();
}

extension StringCasingExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
