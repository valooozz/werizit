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
import 'package:rangement/presentation/widgets/dialog/confirm_dialog.dart';
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
  final Set<int> _selectedItemIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(itemsProvider.notifier).loadItems());
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
        if (_selectedItemIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else if (_isSelectionMode) {
        _selectedItemIds.add(itemId);
      }
    });
  }

  void _enterSelectionMode(int itemId) {
    setState(() {
      _isSelectionMode = true;
      _selectedItemIds.add(itemId);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedItemIds.clear();
    });
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItemIds.isEmpty) return;

    final confirmed = await ConfirmDialog.show(
      context,
      title: LocaleKeys.common_confirm_delete_multiple.tr(
        args: [_selectedItemIds.length.toString()],
      ),
      message: LocaleKeys.item_delete_warning.tr(),
    );

    if (confirmed != true || !mounted) return;

    await ref
        .read(itemsProvider.notifier)
        .deleteItems(_selectedItemIds.toList());
    showAppSnackBar(
      LocaleKeys.item_deleted_multiple.tr(
        args: [_selectedItemIds.length.toString()],
      ),
    );
    _exitSelectionMode();
  }

  Future<void> _moveSelectedItemsToBox() async {
    if (_selectedItemIds.isEmpty) return;

    await ref
        .read(itemsProvider.notifier)
        .putItemsIntoBox(_selectedItemIds.toList());
    showAppSnackBar(
      LocaleKeys.box_added.tr(args: [_selectedItemIds.length.toString()]),
    );
    _exitSelectionMode();
  }

  Future<void> _renameSelectedItem() async {
    if (_selectedItemIds.length != 1) return;

    final itemId = _selectedItemIds.first;
    final items = ref.read(itemsProvider);
    final item = items.firstWhere((i) => i.id == itemId);

    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [item.name]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_rename.tr(),
      onConfirm: (text) async {
        await ref.read(itemsProvider.notifier).renameItem(itemId, text);
        showAppSnackBar(LocaleKeys.item_renamed.tr());
        _exitSelectionMode();
      },
    );
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
    showAppSnackBar(LocaleKeys.storage_deleted.tr());
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
      showAppSnackBar(
        LocaleKeys.box_added.tr(args: [selectedItemIds.length.toString()]),
      );
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
      showAppSnackBar(
        LocaleKeys.box_dropped.tr(args: [selectedItemIds.length.toString()]),
      );
    }
  }

  String _getTitle(String shelfName) {
    return _isSelectionMode
        ? LocaleKeys.common_selected.tr(
            args: [_selectedItemIds.length.toString()],
          )
        : shelfName;
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
      title: _getTitle(shelf.name),
      onAdd: _isSelectionMode ? null : () => _showAddDialog(shelf.name),
      onRename: _isSelectionMode
          ? _selectedItemIds.length == 1
                ? _renameSelectedItem
                : null
          : () => _showRenameDialog(shelf.name),
      onDelete: _isSelectionMode ? _deleteSelectedItems : _deleteShelf,
      onSearch: _isSelectionMode ? null : _openSearchScreen,
      onAddToBox: _isSelectionMode
          ? _moveSelectedItemsToBox
          : shelfItems.isEmpty
          ? null
          : () => _addItemsToBox(shelfItems),
      onDropFromBox: _isSelectionMode
          ? null
          : boxItems.isEmpty
          ? null
          : () => _dropItemsFromBox(boxItems),
      onBack: _isSelectionMode ? _exitSelectionMode : null,
      body: shelfItems.isEmpty
          ? Center(child: Text(LocaleKeys.storage_noItem.tr()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ItemsDisplay(
                items: shelfItems,
                selectedItems: _selectedItemIds,
                isSelectionMode: _isSelectionMode,
                onToggleSelection: _toggleItemSelection,
                onItemLongPress: _enterSelectionMode,
              ),
            ),
    );
  }
}
