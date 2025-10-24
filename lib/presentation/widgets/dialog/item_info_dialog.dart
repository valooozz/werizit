import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/dao_provider.dart';
import 'package:rangement/core/providers/items_provider.dart';
import 'package:rangement/data/models/item_info.dart';
import 'package:rangement/generated/locale_keys.g.dart';

class ItemInfoDialog extends ConsumerWidget {
  final int itemId;
  final List<Widget>? actions;

  const ItemInfoDialog({super.key, required this.itemId, this.actions});

  Future<ItemInfo?> _getItemInfo(WidgetRef ref) async {
    final dao = ref.read(daoProvider);
    final allItems = ref.read(itemsProvider);

    final item = allItems.firstWhere((i) => i.id == itemId);
    if (item.shelf == -1) return null;

    return await dao.getItemInfo(item.id!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<ItemInfo?>(
      future: _getItemInfo(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              LocaleKeys.common_error.tr(args: [snapshot.error.toString()]),
            ),
          );
        }

        final item = ref.watch(itemsProvider).firstWhere((i) => i.id == itemId);
        final itemInfo = snapshot.data;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (actions != null) ...actions!,
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        tooltip: LocaleKeys.tooltip_close.tr(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: itemInfo == null
                      ? Text(
                          LocaleKeys.item_inBox.tr(),
                          style: TextStyle(fontSize: 16),
                        )
                      : Column(
                          children: [
                            _buildInfoRow(itemInfo.house),
                            const Icon(Icons.keyboard_double_arrow_down),
                            _buildInfoRow(itemInfo.room),
                            const Icon(Icons.keyboard_double_arrow_down),
                            _buildInfoRow(itemInfo.furniture),
                            const Icon(Icons.keyboard_double_arrow_down),
                            _buildInfoRow(itemInfo.shelf),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String text) =>
      Text(text, style: const TextStyle(fontSize: 18));
}
