import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/furniture/furniture_provider.dart';
import 'package:werizit/core/providers/furniture/furniture_selector.dart';
import 'package:werizit/core/providers/shelf/shelf_provider.dart';
import 'package:werizit/core/providers/shelf/shelf_selector.dart';
import 'package:werizit/data/models/shelf/shelf.dart';
import 'package:werizit/data/models/shelf/shelf_draft.dart';
import 'package:werizit/presentation/screens/shelf_screen.dart';
import 'package:werizit/presentation/screens/storage_screen.dart';

class FurnitureScreen extends ConsumerWidget {
  final int furnitureId;

  const FurnitureScreen({super.key, required this.furnitureId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final furnitureAsync = ref.watch(furnitureByIdProvider(furnitureId));

    return furnitureAsync.when(
      data: (furniture) {
        final shelves = ref.watch(shelvesByFurnitureProvider(furniture.id));

        return StorageScreen<Shelf>(
          parentStorage: furniture,
          storages: shelves,
          onAdd: (name) => ref
              .read(shelfProvider.notifier)
              .add(ShelfDraft(name: name, furniture: furniture.id)),
          onRename: (newName) => ref
              .read(furnitureProvider.notifier)
              .rename(furniture.id, newName),
          onDelete: () =>
              ref.read(furnitureProvider.notifier).remove(furniture.id),
          onTap: (shelf) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ShelfScreen(shelfId: shelf.id)),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Erreur de chargement"),
    );
  }
}
