import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/storage.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';

class StorageScreen<T extends Storage> extends StatelessWidget {
  final Storage? parentStorage;
  final List<T> storages;
  final Future<void> Function(String name) onAdd;
  final Future<void> Function(String newName)? onRename;
  final void Function()? onDelete;
  final void Function(T item)? onTap;
  final void Function()? onBack;

  const StorageScreen({
    super.key,
    this.parentStorage,
    required this.storages,
    required this.onAdd,
    this.onRename,
    this.onDelete,
    this.onTap,
    this.onBack,
  });

  void _showAddDialog(BuildContext context) {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_addIn.tr(
        args: [parentStorage?.name ?? LocaleKeys.common_home.tr()],
      ),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: (text) async {
        await onAdd(text);
        showAppSnackBar(LocaleKeys.storage_added.tr());
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(
        args: [parentStorage?.name ?? LocaleKeys.common_home.tr()],
      ),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_rename.tr(),
      onConfirm: (text) async {
        if (onRename != null) await onRename!(text);
        showAppSnackBar(LocaleKeys.storage_renamed.tr());
      },
    );
  }

  void _openSearchScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
  }

  void _deleteStorage(BuildContext context) {
    if (onDelete == null) return;
    Navigator.pop(context);
    onDelete!();
    showAppSnackBar(LocaleKeys.storage_deleted.tr());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: parentStorage?.name ?? LocaleKeys.common_home.tr(),
      onAdd: () => _showAddDialog(context),
      onSearch: () => _openSearchScreen(context),
      onDelete: onDelete == null ? null : () => _deleteStorage(context),
      onRename: onRename == null ? null : () => _showRenameDialog(context),
      onBack: onBack,
      body: storages.isEmpty
          ? Center(child: Text(LocaleKeys.storage_noElement.tr()))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              itemCount: storages.length,
              itemBuilder: (context, index) {
                final storage = storages[index];
                return StorageCard(
                  storage: storage,
                  onTap: () => onTap?.call(storage),
                );
              },
            ),
    );
  }
}
