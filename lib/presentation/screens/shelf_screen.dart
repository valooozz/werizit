import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/core/providers/shelves_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/shelf.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/dialog/select_items_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';
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

  Future<void> _addItem(String name) async {
    await ref
        .read(itemsProvider.notifier)
        .addItem(Item(name: name, shelf: widget.shelf.id!));
    showAppSnackBar(LocaleKeys.item_added.tr());
  }

  void _showAddDialog() {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_addIn.tr(args: [widget.shelf.name]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: _addItem,
    );
  }

  void _showRenameDialog() async {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [widget.shelf.name]),
      hintText: LocaleKeys.common_rename.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: (text) async {
        await ref.read(shelvesProvider.notifier).rename(widget.shelf.id!, text);
        showAppSnackBar(LocaleKeys.storage_added.tr());
      },
    );
  }

  void _deleteShelf() async {
    Navigator.pop(context);
    await ref.read(shelvesProvider.notifier).remove(widget.shelf.id!);
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
      await ref
          .read(itemsProvider.notifier)
          .putItemsIntoBox(selectedItemIds, widget.shelf.id!);
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
          .dropItemsFromBox(selectedItemIds, widget.shelf.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shelfItems = ref.watch(itemsProvider).shelfItems;
    final boxItems = ref.watch(itemsProvider).boxItems;

    return BaseScreen(
      title: widget.shelf.name,
      onAdd: _showAddDialog,
      onRename: _showRenameDialog,
      onDelete: _deleteShelf,
      onSearch: _openSearchScreen,
      onAddToBox: () => _addItemsToBox(shelfItems),
      onDropFromBox: () => _dropItemsFromBox(boxItems),
      body: shelfItems.isEmpty
          ? Center(child: Text(LocaleKeys.storage_noItem.tr()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemsDisplay(items: shelfItems),
            ),
    );
  }
}
