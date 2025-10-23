import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/houses_provider.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'house_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final housesNotifier = ref.read(housesProvider.notifier);
    final houses = ref.watch(housesProvider).values.toList();

    if (houses.isEmpty) {
      housesNotifier.load();
    }

    return StorageScreen<House>(
      storages: houses,
      onAdd: (name) async =>
          await ref.read(housesProvider.notifier).add(House(name: name)),
      onTap: (house) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HouseScreen(houseId: house.id!)),
        );
      },
    );
  }
}
