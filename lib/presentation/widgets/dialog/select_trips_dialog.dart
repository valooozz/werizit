import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/data/models/thing.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/dialog/select_items_dialog.dart';

class SelectTripsDialog<T extends Thing> extends ConsumerWidget {
  final int itemId;
  const SelectTripsDialog({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();
    final selectedTrips = trips
        .where((trip) => trip.itemIds!.contains(itemId))
        .map((m) => m.id!);

    return SelectItemsDialog(
      items: trips,
      validButtonLabel: LocaleKeys.trips_link.tr(),
      dialogTitle: LocaleKeys.trips_select.tr(),
      startSelectedIds: {...selectedTrips},
    );
  }
}
