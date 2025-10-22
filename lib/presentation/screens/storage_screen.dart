import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/storage_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/storage.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/screens/base_screen.dart';
import 'package:rangement/presentation/screens/search_screen.dart';
import 'package:rangement/presentation/widgets/cards/storage_card.dart';
import 'package:rangement/presentation/widgets/dialog/add_dialog.dart';

class StorageScreen<T extends Storage> extends ConsumerWidget {
  final String title;
  final StateNotifierProvider<BaseStorageNotifier<T>, List<T>> provider;
  final Future<void> Function(String name) onAdd;
  final void Function()? onDelete;
  final void Function(T item)? onTap;
  final void Function()? onBack;

  const StorageScreen({
    super.key,
    required this.title,
    required this.provider,
    required this.onAdd,
    this.onDelete,
    this.onTap,
    this.onBack,
  });

  void _showAddDialog(BuildContext context) {
    AddDialog.show(
      context,
      title: LocaleKeys.common_addIn.tr(args: [title]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: (text) async {
        await onAdd(text);
        showAppSnackBar(LocaleKeys.storage_added.tr());
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storages = ref.watch(provider);

    return BaseScreen(
      title: title,
      onAdd: () => _showAddDialog(context),
      onSearch: () => _openSearchScreen(context),
      onDelete: onDelete == null ? null : () => _deleteStorage(context),
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
