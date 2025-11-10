import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/trips_provider.dart';
import 'package:rangement/data/models/thing.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/select_items_dialog.dart';

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
      startSelectedIds: {...selectedTrips},
    );
  }
}
