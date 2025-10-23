import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/data/models/item_info.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/item_info_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';

class ItemCard extends ConsumerStatefulWidget {
  final Item item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  ConsumerState<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends ConsumerState<ItemCard> {
  final dao = kIsWeb ? MockDAO() : DAO();
  late ItemInfo _itemInfo;

  void _deleteItem() async {
    Navigator.pop(context);
    await ref.read(itemsProvider.notifier).deleteItem(widget.item.id!);
  }

  void _showInfoDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    _itemInfo = await dao.getItemInfo(widget.item.id!);

    if (!mounted) return;

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => ItemInfoDialog(
        itemId: widget.item.id!,
        itemInfo: _itemInfo,
        actions: [
          IconButton(
            onPressed: _showRenameDialog,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteItem();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog() {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [widget.item.name]),
      hintText: LocaleKeys.common_rename.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
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
      child: InkWell(
        onTap: _showInfoDialog,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            widget.item.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text("ID: ${widget.item.id}"),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
