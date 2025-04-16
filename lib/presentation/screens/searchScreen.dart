import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/core/api/PokeApi.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/presentation/screens/DetailScreen.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class Searchscreen extends ConsumerStatefulWidget {
  final String nameOrId;
  const Searchscreen({super.key, required this.nameOrId});

  @override
  ConsumerState<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends ConsumerState<Searchscreen> {
  dynamic pokeData;
  String? error;
  late Future<void> _future;

  Future<void> fetchSpecificPokemon() async {
    try {
      final data = await PokeApi.fetchSinglePokemon(widget.nameOrId);
      if (data != null && data.isNotEmpty) {
        pokeData = data;
        ref.read(allDataProvider.notifier).state = pokeData;
      } else {
        throw Exception("No Pokémon found for '${widget.nameOrId}'");
      }
    } catch (e) {
      error = e.toString();
    }
  }

  @override
  void initState() {
    _future = fetchSpecificPokemon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Text(
                error!,
                style: const TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Detailscreen(name: pokeData["name"], allData: pokeData);
      },
    );
  }
}
