import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/item_info_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';

class ItemCard extends ConsumerStatefulWidget {
  final Item item;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onToggleSelection;
  final VoidCallback? onLongPress;

  const ItemCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onToggleSelection,
    this.onLongPress,
  });

  @override
  ConsumerState<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<ItemCard> {
  void _deleteItem() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: LocaleKeys.common_confirm_delete.tr(args: [widget.item.name]),
      message: LocaleKeys.item_delete_warning.tr(),
    );

    if (confirmed != true || !mounted) return;

    Navigator.pop(context);
    await ref.read(itemsProvider.notifier).deleteItem(widget.item.id!);
    showAppSnackBar(LocaleKeys.item_deleted.tr());
  }

  void _addItemToBox() async {
    Navigator.pop(context);
    await ref.read(itemsProvider.notifier).putItemsIntoBox([widget.item.id!]);
    showAppSnackBar(LocaleKeys.box_added.tr(args: ['1']));
  }

  void _handleTap() async {
    if (widget.isSelectionMode) {
      widget.onToggleSelection!();
    } else {
      _showInfoDialog();
    }
  }

  void _showInfoDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    if (!mounted) return;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => ItemInfoDialog(
        itemId: widget.item.id!,
        actions: [
          if (widget.item.shelf != -1)
            IconButton(
              onPressed: _addItemToBox,
              icon: const Icon(Icons.move_to_inbox),
              tooltip: LocaleKeys.tooltip_addItemToBox.tr(),
            ),
          IconButton(
            onPressed: _showRenameDialog,
            icon: const Icon(Icons.edit),
            tooltip: LocaleKeys.tooltip_edit.tr(),
          ),
          IconButton(
            onPressed: () {
              _deleteItem();
            },
            icon: const Icon(Icons.delete),
            tooltip: LocaleKeys.tooltip_delete.tr(),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog() {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [widget.item.name]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_rename.tr(),
      onConfirm: (text) async {
        await ref
            .read(itemsProvider.notifier)
            .renameItem(widget.item.id!, text);
        showAppSnackBar(LocaleKeys.item_renamed.tr());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: widget.isSelected ? Theme.of(context).colorScheme.primary : null,
      elevation: widget.isSelected ? 5 : 1,
      child: InkWell(
        onTap: _handleTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            ListTile(
              title: Text(
                widget.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
                ),
              ),
            ),

            if (widget.isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
