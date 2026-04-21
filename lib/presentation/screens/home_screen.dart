import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/house/house_provider.dart';
import 'package:werizit/core/providers/house/house_selector.dart';
import 'package:werizit/data/models/house/house.dart';
import 'package:werizit/data/models/house/house_draft.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

import 'house_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final houses = ref.watch(housesListProvider);

    return StorageScreen<House>(
      storages: houses,
      onAdd: (name) async =>
          await ref.read(houseProvider.notifier).add(HouseDraft(name: name)),
      onTap: (house) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HouseScreen(houseId: house.id)),
        );
      },
      isHome: true,
    );
  }
}
