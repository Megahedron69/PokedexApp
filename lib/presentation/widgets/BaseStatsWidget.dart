import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class BaseStatsWidget extends ConsumerWidget {
  const BaseStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allData = ref.watch(allDataProvider);
    final stats = allData["stats"] as List<dynamic>;
    final pokeColor = ref.watch(pokeMonColorProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Base Stats",
            style: TextStyle(
              color: pokeColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 12),
          ...stats.map((stat) {
            final statName = stat["stat"]["name"];
            final formattedName = _formatStatName(statName);
            final baseStat = stat["base_stat"];
            final color = _getStatColor(statName);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      formattedName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      baseStat.toString(),
                      style: TextStyle(color: color),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: baseStat / 200,
                        minHeight: 10,
                        color: color,
                        backgroundColor: color.withAlpha(50),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatStatName(String name) {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SpA';
      case 'special-defense':
        return 'SpD';
      case 'speed':
        return 'SPD';
      default:
        return name.toUpperCase();
    }
  }

  Color _getStatColor(String statName) {
    switch (statName) {
      case 'hp':
        return Colors.redAccent;
      case 'attack':
        return Colors.deepOrange;
      case 'defense':
        return Colors.amber;
      case 'special-attack':
        return Colors.deepPurpleAccent;
      case 'special-defense':
        return Colors.green;
      case 'speed':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
