import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/models/house.dart';
import 'package:rangement/presentation/screens/house_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dao = DAO();
  List<House> houses = [];

  @override
  void initState() {
    super.initState();
    _loadHouses();
  }

  Future<void> _loadHouses() async {
    final data = await dao.getHouses();
    setState(() => houses = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maisons")),
      body: ListView.builder(
        itemCount: houses.length,
        itemBuilder: (context, index) {
          final house = houses[index];
          return StorageCard(
            storage: house,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HouseScreen(house: house)),
            ),
          );
        },
      ),
    );
  }
}
