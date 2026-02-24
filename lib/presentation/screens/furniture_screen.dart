import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/furnitures_provider.dart';
import 'package:werizit/core/providers/shelves_provider.dart';
import 'package:werizit/data/models/furniture.dart';
import 'package:werizit/data/models/shelf.dart';
import 'package:werizit/presentation/screens/shelf_screen.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

class FurnitureScreen extends ConsumerWidget {
  final int furnitureId;

  const FurnitureScreen({super.key, required this.furnitureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelvesNotifier = ref.read(shelvesProvider.notifier);
    final furnituresNotifier = ref.read(furnituresProvider.notifier);

    final furniture = ref
        .watch(furnituresProvider)
        .values
        .firstWhere(
          (f) => f.id == furnitureId,
          orElse: () => Furniture(name: '', room: -1),
        );

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
          MaterialPageRoute(builder: (_) => ShelfScreen(shelfId: shelf.id!)),
        );
      },
    );
  }
}
