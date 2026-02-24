import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/dao_provider.dart';
import 'package:werizit/data/models/item.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/display/items_display.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late Future<List<Item>> _futureItems;
  bool _emptySearch = true;

  @override
  void initState() {
    super.initState();
    _futureItems = Future.value([]);
  }

  void _refreshSearch(String searchText) {
    final dao = ref.read(daoProvider);

    setState(() {
      if (searchText.isEmpty) {
        _futureItems = Future.value([]);
        _emptySearch = true;
      } else {
        _futureItems = dao.searchItems(searchText);
        _emptySearch = false;
      }
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

                  return ItemsDisplay(items: items, isSelectionMode: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
