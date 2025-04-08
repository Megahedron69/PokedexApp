import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class CardWidget extends ConsumerWidget {
  final String name, imageUrl, type;
  final Color color;
  final int number, hp;
  final List<String> labels;
  final List<String> values;
  final Map<String, dynamic> allData;

  const CardWidget({
    super.key,
    required this.name,
    required this.color,
    required this.imageUrl,
    required this.number,
    required this.hp,
    required this.type,
    required this.values,
    required this.labels,
    required this.allData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 15,
      color: Colors.white, // Background color of the card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 6.0,
          right: 6.0,
          top: 3.6,
          bottom: 3.6,
        ),
        child: InkWell(
          splashColor: color.withAlpha(80),
          onTap: () {
            ref.read(allDataProvider.notifier).state = allData;
            context.go("/details/$name", extra: allData);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Chip(
                    label: Text("#${number > 9 ? number : "0$number"}"),
                    backgroundColor: color.withAlpha(60),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  Chip(
                    label: Text("Hp $hp"),
                    backgroundColor: color.withAlpha(60),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ],
              ),
              Image.network(
                imageUrl,
                height: 100,
                width: 100,
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
                  return Icon(Icons.error, size: 50);
                },
              ),

              Chip(
                label: Text(type.capitalize()),
                elevation: 15,
                backgroundColor: color.withAlpha(60),
              ), // Adds spacing
              Text(
                name.capitalize(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              _buildStat(values, labels),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildStat(List<String> values, List<String> labels) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: List.generate(
      labels.length,
      (index) => Column(
        children: [
          Text(
            labels[index].toString(),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Text(
            values[index],
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
