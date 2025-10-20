import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/presentation/widgets/display/items_display.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final dao = kIsWeb ? MockDAO() : DAO();
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rechercher un objet')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SearchBar(
              hintText: 'Rechercher...',
              onChanged: (searchText) {
                setState(() {
                  _futureItems = searchText.isEmpty
                      ? Future.value([])
                      : (dao.searchItems(searchText));
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Erreur : ${snapshot.error}"));
                  }

                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return const Center(child: Text("Aucun élément trouvé"));
                  }

                  return ItemsDisplay(items: items);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
