import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/houses_provider.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/presentation/screens/storage_screen.dart';

import 'house_screen.dart';

class HomeScreen extends ConsumerWidget {
  final dao = kIsWeb ? MockDAO() : DAO();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StorageScreen<House>(
      title: "Accueil",
      provider: housesProvider,
      onAdd: (name) async =>
          await ref.read(housesProvider.notifier).add(House(name: name)),
      onTap: (house) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HouseScreen(house: house)),
        );
      },
    );
  }
}
