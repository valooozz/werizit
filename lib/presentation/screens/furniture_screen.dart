import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/furniture.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/presentation/screens/shelf_screen.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

class FurnitureScreen extends StatelessWidget {
  final Furniture furniture;
  final dao = kIsWeb ? MockDAO() : DAO();

  FurnitureScreen({super.key, required this.furniture});

  @override
  Widget build(BuildContext context) {
    return StorageScreen<Shelf>(
      title: furniture.name,
      fetchItems: () => dao.getShelvesByFurniture(furniture.id!),
      onAdd: (name) =>
          dao.insertShelf(Shelf(name: name, furniture: furniture.id!)),
      onTap: (shelf) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ShelfScreen(shelf: shelf), // ItemsScreen reste spécifique
          ),
        );
      },
    );
  }
}
