import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/trips_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/trip.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/confirm_dialog.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';

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
