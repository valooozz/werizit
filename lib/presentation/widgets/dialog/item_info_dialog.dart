import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/item/item_selector.dart';
import 'package:werizit/generated/locale_keys.g.dart';

class ItemInfoDialog extends ConsumerWidget {
  final int itemId;
  final List<Widget>? actions;

  const ItemInfoDialog({super.key, required this.itemId, this.actions});

  Widget _buildInfoRow(String text) =>
      Text(text, style: const TextStyle(fontSize: 18));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemInfoAsync = ref.watch(itemInfoByIdProvider(itemId));

    return itemInfoAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (e, _) =>
          Center(child: Text(LocaleKeys.common_error.tr(args: [e.toString()]))),

      data: (itemInfo) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              itemInfo.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                            tooltip: LocaleKeys.tooltip_close.tr(),
                          ),
                        ],
                      ),
                      if (actions != null) ...[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: actions!,
                        ),
                      ],
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: itemInfo.shelf == 'box'
                      ? Text(
                          LocaleKeys.item_inBox.tr(),
                          style: TextStyle(fontSize: 16),
                        )
                      : itemInfo.shelf == 'wardrobe'
                      ? Text(
                          LocaleKeys.item_inWardrobe.tr(),
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
}
