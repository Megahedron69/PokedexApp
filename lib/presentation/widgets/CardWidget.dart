import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/SvgUrlHelper.dart';
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    return Card(
      elevation: 45,
      color: theme.cardColor, // Dynamic card background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.sw * 0.006,
          vertical: context.sh * 0.0008,
        ),
        child: InkWell(
          splashColor: color.withAlpha(80),
          onTap: () {
            ref.read(allDataProvider.notifier).state = allData;
            ref.read(pokeMonColorProvider.notifier).state = getColorForType(
              type,
            );
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
                    labelStyle: TextStyle(color: textColor),
                  ),
                  Chip(
                    label: Text("Hp $hp"),
                    backgroundColor: color.withAlpha(60),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    labelStyle: TextStyle(color: textColor),
                  ),
                ],
              ),
              Hero(
                tag: allData["name"],
                child: Image.network(
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
                    return const Icon(Icons.error, size: 50);
                  },
                ),
              ),
              Chip(
                label: Text(type.capitalize()),
                elevation: 15,
                backgroundColor: color.withAlpha(60),
                avatar: getTypeIcon(type),
                labelStyle: TextStyle(color: textColor),
              ),
              Hero(
                tag: "$name+z",
                child: Material(
                  color: Colors.transparent, // Transparent to maintain the look
                  child: Text(
                    name.capitalize(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              _buildStat(values, labels, textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(List<String> values, List<String> labels, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        labels.length,
        (index) => Column(
          children: [
            Text(
              labels[index].toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Text(
              values[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
