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
import 'package:rangement/presentation/widgets/dialog/add_dialog.dart';
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
    Future.microtask(
      () => ref.read(itemsProvider.notifier).loadItems(widget.shelf.id!),
    );
  }

  Future<void> _addItem(String text) async {
    await ref
        .read(itemsProvider.notifier)
        .addItem(Item(name: text, shelf: widget.shelf.id!));
    showAppSnackBar(LocaleKeys.item_added.tr());
  }

  void _showAddDialog() {
    AddDialog.show(
      context,
      title: LocaleKeys.common_addIn.tr(args: [widget.shelf.name]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: _addItem,
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
      onAdd: _showAddDialog,
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
