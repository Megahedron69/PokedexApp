import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:new_app/core/api/PokeApi.dart";
import "package:new_app/core/utils/ColorHelper.dart";
import "package:new_app/presentation/widgets/CardWidget.dart";
import "package:new_app/presentation/widgets/chip_widget.dart";
import "package:new_app/providers/pokemon.providers.dart";

class ListViewBuildWidget extends ConsumerStatefulWidget {
  const ListViewBuildWidget({super.key});

  @override
  _ListViewBuildWidgetState createState() => _ListViewBuildWidgetState();
}

class _ListViewBuildWidgetState extends ConsumerState<ListViewBuildWidget> {
  List<dynamic> pokemonList = [], details = [];
  late ScrollController _scrollController;
  bool loading = false;
  bool isFetchingMore = false;
  int offset = 0;
  String? error;
  final int limit = 30;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    getMyPokemonData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !isFetchingMore &&
        !loading) {
      fetchMorePokemon();
    }
  }

  Future<void> getMyPokemonData() async {
    setState(() => loading = true);
    try {
      final newPokemonList = await PokeApi.fetchMyPokemon(
        limit: limit,
        offset: offset,
        apiName: "pokemon",
      );

      for (var item in newPokemonList) {
        var detail = await PokeApi.fetchMyPokemon(
          limit: 1,
          apiName: "pokemon",
          pokemonName: item["name"],
        );
        details.add(detail[0]);
      }

      pokemonList.addAll(newPokemonList);
      offset += limit;
    } catch (e) {
      setState(() {
        error = e.toString();
        debugPrint("error occurred $e");
      });
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> fetchMorePokemon() async {
    setState(() => isFetchingMore = true);
    try {
      final morePokemon = await PokeApi.fetchMyPokemon(
        limit: limit,
        offset: offset,
        apiName: "pokemon",
      );

      for (var item in morePokemon) {
        var detail = await PokeApi.fetchMyPokemon(
          limit: 1,
          apiName: "pokemon",
          pokemonName: item["name"],
        );
        details.add(detail[0]);
      }

      pokemonList.addAll(morePokemon);
      offset += limit;
    } catch (e) {
      debugPrint("error during fetch more: $e");
    } finally {
      setState(() => isFetchingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedFilters = ref.watch(selectedFilterProvider);

    if (loading && pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (error != null) {
      return Center(
        child: Text(
          "Error: $error",
          style: const TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      final filteredList =
          selectedFilters.contains('all')
              ? details
              : details.where((pokemon) {
                final types =
                    pokemon['types'].map((t) => t['type']['name']).toList();
                return types.any((type) => selectedFilters.contains(type));
              }).toList();
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                ChipRowWidget(),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.67,
                        ),
                    itemCount: filteredList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredList.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child:
                                isFetchingMore
                                    ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        );
                      }

                      final pokemon = filteredList[index];
                      return CardWidget(
                        name: pokemon["name"],
                        color: getColorForType(
                          pokemon["types"][0]["type"]["name"],
                        ),
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
              ],
            ),
          ),
        ),
      );
    }
  }
}
