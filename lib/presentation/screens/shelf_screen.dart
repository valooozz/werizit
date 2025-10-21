import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/display/items_display.dart';

class ShelfScreen extends ConsumerStatefulWidget {
  final Shelf shelf;
  const ShelfScreen({super.key, required this.shelf});

  @override
  ConsumerState<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends ConsumerState<ShelfScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(itemsProvider.notifier).loadItems(widget.shelf.id!);
  }

  void _addItem() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.common_addIn.tr(args: [widget.shelf.name])),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: LocaleKeys.common_name.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.common_cancel.tr()),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isEmpty) return;
              Navigator.pop(context);
              await ref
                  .read(itemsProvider.notifier)
                  .addItem(
                    Item(name: controller.text, shelf: widget.shelf.id!),
                  );
              showAppSnackBar(LocaleKeys.item_added.tr());
            },
            child: Text(LocaleKeys.common_add.tr()),
          ),
        ],
      ),
    );
  }

  void _search() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(itemsProvider);
    return BaseScreen(
      title: widget.shelf.name,
      onAdd: _addItem,
      onSearch: _search,
      body: items.isEmpty
          ? Center(child: Text(LocaleKeys.storage_noItem.tr()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemsDisplay(items: items),
            ),
    );
  }
}
