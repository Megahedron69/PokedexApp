import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/providers/pokemon.providers.dart';
import 'package:new_app/core/api/PokeApi.dart';

class EvolutionChainWidget extends ConsumerStatefulWidget {
  const EvolutionChainWidget({super.key});

  @override
  ConsumerState<EvolutionChainWidget> createState() =>
      _EvolutionChainWidgetState();
}

class _EvolutionChainWidgetState extends ConsumerState<EvolutionChainWidget> {
  List<Map<String, String>> evolutions = [];
  bool loading = true;
  String err = "";

  @override
  void initState() {
    super.initState();
    fetchEvolutions();
  }

  Future<void> fetchEvolutions() async {
    final allData = ref.read(allDataProvider);
    final pokemonName = allData["name"];

    try {
      final species = await PokeApi.fetchMyPokemon(
        apiName: "pokemon-species",
        pokemonName: pokemonName,
      );

      final evoChainUrl = species[0]["evolution_chain"]["url"];
      final evoChain = await PokeApi.fetchFromUrl(evoChainUrl);

      List<String> evolutionNames = [];

      void extractNames(dynamic chain) {
        if (chain == null) return;
        evolutionNames.add(chain["species"]["name"]);
        if (chain["evolves_to"] != null && chain["evolves_to"].isNotEmpty) {
          extractNames(chain["evolves_to"][0]);
        }
      }

      extractNames(evoChain["chain"]);

      List<Map<String, String>> results = [];

      for (var name in evolutionNames) {
        final pokeData = await PokeApi.fetchMyPokemon(
          apiName: "pokemon",
          pokemonName: name,
        );
        final spriteUrl =
            pokeData[0]["sprites"]["other"]["official-artwork"]["front_default"];
        results.add({"name": name, "sprite": spriteUrl});
      }

      setState(() {
        evolutions = results;
        loading = false;
      });
    } catch (e) {
      print("Error fetching evolutions: $e");
      setState(() => loading = false);
    }
  }

  Future<void> navigToThatPokemon({required String pokeName}) async {
    try {
      setState(() {
        loading = true;
      });
      final data = await PokeApi.fetchSinglePokemon(pokeName);
      context.go('/details/$pokeName', extra: data);
      ref.read(allDataProvider.notifier).state = data;
      DefaultTabController.of(context).animateTo(0);
    } catch (e) {
      setState(() {
        err = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokeColor = ref.watch(pokeMonColorProvider);

    if (loading) {
      return Center(child: CircularProgressIndicator(color: pokeColor));
    }
    if (err.isNotEmpty) {
      return Center(child: Text(err, style: TextStyle(color: Colors.red)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Evolution Chain",
            style: TextStyle(
              color: pokeColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children:
                evolutions.map((evo) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkResponse(
                        onTap: () {
                          navigToThatPokemon(pokeName: "${evo["name"]}");
                        },
                        highlightColor: pokeColor,
                        highlightShape: BoxShape.circle,
                        child: CircleAvatar(
                          backgroundColor: pokeColor.withAlpha(90),
                          radius: context.sw * 0.2,
                          backgroundImage: NetworkImage(evo["sprite"] ?? ""),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        evo["name"]?.capitalize() ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
