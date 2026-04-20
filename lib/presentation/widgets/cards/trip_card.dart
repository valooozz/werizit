import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/item/item_provider.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/core/utils/snackbar_utils.dart';
import 'package:werizit/data/models/item.dart';
import 'package:werizit/data/models/trip.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:werizit/presentation/widgets/dialog/select_dialog.dart';
import 'package:werizit/presentation/widgets/dialog/text_field_dialog.dart';

class TripCard extends ConsumerWidget {
  final Trip trip;

  const TripCard({super.key, required this.trip});

  void _deleteTrip(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: LocaleKeys.common_confirm_delete.tr(args: [trip.name]),
      message: LocaleKeys.common_delete_warning.tr(),
    );

    if (confirmed != true) return;

    await ref.read(tripsProvider.notifier).deleteTrip(trip.id!);
    showAppSnackBar(LocaleKeys.trips_deleted.tr());
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref) {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.common_renameOf.tr(args: [trip.name]),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_rename.tr(),
      onConfirm: (text) async {
        await ref.read(tripsProvider.notifier).renameTrip(trip.id!, text);
        showAppSnackBar(LocaleKeys.trips_renamed.tr());
      },
    );
  }

  Future<void> _showLinkDialog(
    BuildContext context,
    WidgetRef ref,
    List<Item> items,
  ) async {
    final startSelectedItemIds = trip.itemIds;
    final selectedItemIds = await showDialog<List<int>>(
      context: context,
      builder: (_) => SelectDialog<Item>(
        items: items,
        validButtonLabel: LocaleKeys.trips_link.tr(),
        dialogTitle: LocaleKeys.item_select.tr(),
        startSelectedIds: {...?startSelectedItemIds},
        cantBeEmpty: false,
      ),
    );

    if (selectedItemIds == null || startSelectedItemIds == null) {
      return;
    }

    final oldSet = startSelectedItemIds.toSet();
    final newSet = selectedItemIds.toSet();
    final itemsToAdd = newSet.difference(oldSet).toList();
    final itemsToRemove = oldSet.difference(newSet).toList();
    await ref
        .read(tripsProvider.notifier)
        .updateTripLinks(trip.id!, itemsToAdd, itemsToRemove);
    showAppSnackBar(LocaleKeys.trips_linked.tr(args: [trip.name]));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 1,
      child: ListTile(
        title: Text(trip.name, style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () async {
                final itemsAsync = ref.read(itemProvider);

                await itemsAsync.when(
                  data: (items) async {
                    await _showLinkDialog(context, ref, items.values.toList());
                  },
                  loading: () async {
                    showAppSnackBar("Chargement...");
                  },
                  error: (e, _) async {
                    showAppSnackBar("Erreur");
                  },
                );
              },
              icon: const Icon(Icons.link),
            ),
            IconButton(
              onPressed: () => _showRenameDialog(context, ref),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _deleteTrip(context, ref),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
