import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/furnitures_provider.dart';
import 'package:rangement/core/providers/shelves_provider.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/screens/shelf_screen.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

class FurnitureScreen extends ConsumerWidget {
  final Furniture furniture;

  const FurnitureScreen({super.key, required this.furniture});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelvesNotifier = ref.read(shelvesProvider.notifier);
    final furnituresNotifier = ref.read(furnituresProvider.notifier);

    final shelves = ref
        .watch(shelvesProvider)
        .values
        .where((s) => s.furniture == furniture.id)
        .toList();

    if (shelves.isEmpty) {
      shelvesNotifier.load();
    }

    return StorageScreen<Shelf>(
      parentStorage: furniture,
      storages: shelves,
      onAdd: (name) async => await shelvesNotifier.add(
        Shelf(name: name, furniture: furniture.id!),
      ),
      onRename: (newName) async =>
          await furnituresNotifier.rename(furniture.id!, newName),
      onDelete: () async => await furnituresNotifier.remove(furniture.id!),
      onTap: (shelf) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShelfScreen(shelf: shelf)),
        );
      },
    );
  }
}
