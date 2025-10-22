import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/furnitures_provider.dart';
import 'package:rangement/core/providers/shelves_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/screens/shelf_screen.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

class FurnitureScreen extends ConsumerWidget {
  final Furniture furniture;
  final dao = kIsWeb ? MockDAO() : DAO();

  FurnitureScreen({super.key, required this.furniture});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StorageScreen<Shelf>(
      title: furniture.name,
      provider: shelvesProvider(furniture.id!),
      onAdd: (name) async => await ref
          .read(shelvesProvider(furniture.id!).notifier)
          .add(Shelf(name: name, furniture: furniture.id!)),
      onDelete: () async => await ref
          .read(furnituresProvider(furniture.id!).notifier)
          .delete(furniture.id!, furniture.room),
      onTap: (shelf) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShelfScreen(shelf: shelf)),
        );
      },
    );
  }
}
