import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/items_provider.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/data/models/item.dart';
import 'package:werizit/data/models/trip.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/cards/item_card.dart';
import 'package:werizit/presentation/widgets/dialog/select_dialog.dart';

class PrepareTripScreen extends ConsumerWidget {
  const PrepareTripScreen({super.key});

  List _getUniqueItemsFromTrips(List<Trip> trips) {
    Set setResult = {};
    for (final trip in trips) {
      setResult = {...setResult, ...trip.itemIds!.toSet()};
    }
    List listResult = setResult.toList();
    listResult.sort();
    return listResult;
  }

  Future<void> _showSelectDialog(
    BuildContext context,
    WidgetRef ref,
    List<Trip> trips,
  ) async {
    final startSelectedTrips = trips
        .where((trip) => trip.selected)
        .map((m) => m.id!);

    final selectedTripIds = await showDialog<List<int>>(
      context: context,
      builder: (_) => SelectDialog<Trip>(
        items: trips,
        validButtonLabel: LocaleKeys.prepare_validate.tr(),
        dialogTitle: LocaleKeys.trips_select.tr(),
        startSelectedIds: {...startSelectedTrips},
        cantBeEmpty: false,
      ),
    );

    if (selectedTripIds == null) {
      return;
    }

    await ref.read(tripsProvider.notifier).updateSelectedTrips(selectedTripIds);
  }

  void _onItemPress(WidgetRef ref, Item item) {
    if (item.taken) {
      ref.read(itemsProvider.notifier).untakeItem(item.id!);
    } else {
      ref.read(itemsProvider.notifier).takeItem(item.id!);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTrips = ref.watch(tripsProvider).toList();
    final allItems = ref.watch(itemsProvider).toList();
    final selectedTrips = ref.watch(
      tripsProvider.select((trips) => trips.where((t) => t.selected).toList()),
    );

    final itemIds = _getUniqueItemsFromTrips(selectedTrips);
    final itemsToTake = allItems
        .where((item) => itemIds.contains(item.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.prepare_title.tr()),
        actions: [
          IconButton(
            onPressed: () => _showSelectDialog(context, ref, allTrips),
            icon: const Icon(Icons.luggage),
            tooltip: LocaleKeys.tooltip_selectTrips.tr(),
          ),
        ],
      ),
      body: 0 == 1
          ? Center(child: Text(LocaleKeys.storage_noItem.tr()))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                itemCount: itemsToTake.length,
                itemBuilder: (context, index) {
                  final item = itemsToTake[index];

                  return ItemCard(
                    item: item,
                    isSelected: item.taken,
                    isSelectionMode: true,
                    showInfoOnLongPress: true,
                    onToggleSelection: () => _onItemPress(ref, item),
                  );
                },
              ),
            ),
    );
  }
}
