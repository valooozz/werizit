import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/furniture/furniture_provider.dart';
import 'package:werizit/core/providers/furniture/furniture_selector.dart';
import 'package:werizit/core/providers/shelf/shelf_provider.dart';
import 'package:werizit/core/providers/shelf/shelf_selector.dart';
import 'package:werizit/data/models/shelf.dart';
import 'package:werizit/presentation/screens/shelf_screen.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

class FurnitureScreen extends ConsumerWidget {
  final int furnitureId;

  const FurnitureScreen({super.key, required this.furnitureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelvesNotifier = ref.read(shelfProvider.notifier);
    final furnituresNotifier = ref.read(furnitureProvider.notifier);

    final furniture = ref.watch(furnitureByIdProvider(furnitureId));

    final shelves = ref.watch(shelvesByFurnitureProvider(furniture!.id!));

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
