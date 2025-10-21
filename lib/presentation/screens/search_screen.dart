import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/display/items_display.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final dao = kIsWeb ? MockDAO() : DAO();
  late Future<List<Item>> _futureItems;
  bool _emptySearch = true;

  @override
  void initState() {
    super.initState();
    _futureItems = Future.value([]);
  }

  void _refreshSearch(searchText) {
    setState(() {
      _futureItems = searchText.isEmpty
          ? Future.value([])
          : (dao.searchItems(searchText));
      _emptySearch = searchText == '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.search_title.tr())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          spacing: 8,
          children: [
            SearchBar(
              hintText: LocaleKeys.search_hintText.tr(),
              onChanged: _refreshSearch,
            ),
            Expanded(
              child: FutureBuilder<List<Item>>(
                future: _futureItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        LocaleKeys.common_error.tr(
                          args: [snapshot.error.toString()],
                        ),
                      ),
                    );
                  }

                  final items = snapshot.data ?? [];
                  if (_emptySearch) {
                    return Center(
                      child: Text(LocaleKeys.search_emptySearch.tr()),
                    );
                  }
                  if (items.isEmpty) {
                    return Center(child: Text(LocaleKeys.search_noItem.tr()));
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
