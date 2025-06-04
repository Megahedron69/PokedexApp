import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/core/utils/ColorHelper.dart';
import 'package:new_app/core/utils/Extensions.dart';
import 'package:new_app/core/utils/SvgUrlHelper.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class ChipRowWidget extends ConsumerStatefulWidget {
  const ChipRowWidget({super.key});

  @override
  ConsumerState<ChipRowWidget> createState() => _ChipRowWidgetState();
}

class _ChipRowWidgetState extends ConsumerState<ChipRowWidget> {
  final List<String> categoriesList = typeColors.keys.toList();
  List<String> selectedChips = ['all'];

  void _handleChipTap(String chipName) {
    setState(() {
      selectedChips = [chipName];
    });
    ref.read(selectedFilterProvider.notifier).state = selectedChips;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.sw * 0.02),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesList.length,

          itemBuilder: (context, index) {
            final chipName = categoriesList[index];
            final isSelected = selectedChips.contains(chipName);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IndiChip(
                chipName: chipName,
                isSelected: isSelected,
                onTap: () => _handleChipTap(chipName),
              ),
            );
          },
        ),
      ),
    );
  }
}

class IndiChip extends StatelessWidget {
  final String chipName;
  final bool isSelected;
  final VoidCallback onTap;

  const IndiChip({
    super.key,
    required this.chipName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = getColorForType(chipName);
    final bgColor =
        isSelected ? baseColor.withAlpha(150) : baseColor.withAlpha(90);
    final scale = isSelected ? 1.0 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(scale),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            getTypeIcon(chipName),
            const SizedBox(width: 8.0),
            Text(
              chipName.capitalize(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
