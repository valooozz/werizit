import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/core/providers/shelves_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/dialog/select_items_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';
import 'package:rangement/presentation/widgets/display/items_display.dart';

class ShelfScreen extends ConsumerStatefulWidget {
  final int shelfId;
  const ShelfScreen({super.key, required this.shelfId});

  @override
  ConsumerState<ShelfScreen> createState() => _ShelfScreenState();
}

class _ShelfScreenState extends ConsumerState<ShelfScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(itemsProvider.notifier).loadItems());
  }

  Future<void> _addItem(String name) async {
    await ref
        .read(itemsProvider.notifier)
        .addItem(Item(name: name, shelf: widget.shelfId));
    showAppSnackBar(LocaleKeys.item_added.tr());
  }

  void _showAddDialog(String shelfName) {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_addIn.tr(args: [shelfName]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: _addItem,
    );
  }

  void _showRenameDialog(String shelfName) async {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [shelfName]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_rename.tr(),
      onConfirm: (text) async {
        await ref.read(shelvesProvider.notifier).rename(widget.shelfId, text);
        showAppSnackBar(LocaleKeys.storage_renamed.tr());
      },
    );
  }

  void _deleteShelf() async {
    Navigator.pop(context);
    await ref.read(shelvesProvider.notifier).remove(widget.shelfId);
  }

  void _openSearchScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
  }

  Future<void> _addItemsToBox(List<Item> items) async {
    final selectedItemIds = await showDialog<List<int>>(
      context: context,
      builder: (_) => SelectItemsDialog(items: items),
    );

    if (selectedItemIds != null && selectedItemIds.isNotEmpty) {
      await ref.read(itemsProvider.notifier).putItemsIntoBox(selectedItemIds);
    }
  }

  Future<void> _dropItemsFromBox(List<Item> items) async {
    final selectedItemIds = await showDialog<List<int>>(
      context: context,
      builder: (_) => SelectItemsDialog(items: items),
    );

    if (selectedItemIds != null && selectedItemIds.isNotEmpty) {
      await ref
          .read(itemsProvider.notifier)
          .dropItemsFromBox(selectedItemIds, widget.shelfId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shelf = ref
        .watch(shelvesProvider)
        .values
        .where((s) => s.id == widget.shelfId)
        .first;

    final allItems = ref.watch(itemsProvider);
    final shelfItems = allItems.where((i) => i.shelf == shelf.id).toList();
    final boxItems = allItems.where((i) => i.shelf == -1).toList();

    return BaseScreen(
      title: shelf.name,
      onAdd: () => _showAddDialog(shelf.name),
      onRename: () => _showRenameDialog(shelf.name),
      onDelete: _deleteShelf,
      onSearch: _openSearchScreen,
      onAddToBox: shelfItems.isEmpty ? null : () => _addItemsToBox(shelfItems),
      onDropFromBox: boxItems.isEmpty
          ? null
          : () => _dropItemsFromBox(boxItems),
      body: shelfItems.isEmpty
          ? Center(child: Text(LocaleKeys.storage_noItem.tr()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemsDisplay(items: shelfItems),
            ),
    );
  }
}
