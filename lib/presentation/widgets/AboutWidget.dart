import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/core/api/PokeApi.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class AboutWidget extends ConsumerWidget {
  const AboutWidget({super.key});
  Future<String> getPokemonDesc(String pokeName) async {
    try {
      final data = await PokeApi.fetchMyPokemon(
        apiName: "pokemon-species",
        pokemonName: pokeName,
      );

      final entry = (data[0]["flavor_text_entries"] as List).firstWhere(
        (e) => e["language"]["name"] == "en",
        orElse: () => null,
      );

      return entry != null
          ? entry["flavor_text"]
              .toString()
              .replaceAll('\n', ' ')
              .replaceAll('\f', ' ')
          : "No English description found.";
    } catch (e) {
      throw FormatException("Error in getting description: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allData = ref.watch(allDataProvider);
    return Center(
      child: Text(
        "Selected: ${allData["name"]}",
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
