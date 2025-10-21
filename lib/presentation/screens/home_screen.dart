import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'house_screen.dart';

class HomeScreen extends StatelessWidget {
  final dao = kIsWeb ? MockDAO() : DAO();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageScreen<House>(
      title: "Accueil",
      fetchItems: dao.getHouses,
      onAdd: (name) => dao.insertHouse(House(name: name)),
      onTap: (house) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HouseScreen(house: house)),
        );
      },
    );
  }
}
