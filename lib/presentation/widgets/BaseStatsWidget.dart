import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class BaseStatsWidget extends ConsumerWidget {
  const BaseStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allData = ref.watch(allDataProvider);
    return Center(child: Text("${allData["id"]}"));
  }
}
