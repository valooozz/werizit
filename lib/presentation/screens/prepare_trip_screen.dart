import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/item/item_provider.dart';
import 'package:werizit/core/providers/item/item_selector.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/data/models/item.dart';
import 'package:werizit/data/models/trip.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/cards/item_card.dart';
import 'package:werizit/presentation/widgets/dialog/select_dialog.dart';

class PrepareTripScreen extends ConsumerWidget {
  const PrepareTripScreen({super.key});

  List<int> _getUniqueItemsFromTrips(List<Trip> trips) {
    Set<int> setResult = {};
    for (final trip in trips) {
      setResult = {...setResult, ...trip.itemIds!.toSet()};
    }
    List<int> listResult = setResult.toList();
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
      ref.read(itemProvider.notifier).untake(item.id!);
    } else {
      ref.read(itemProvider.notifier).take(item.id!);
    }
  }

  void _untakeAllItems(WidgetRef ref) {
    ref.read(itemProvider.notifier).untakeAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTrips = ref.watch(tripsProvider).toList();
    final selectedTrips = ref.watch(
      tripsProvider.select((trips) => trips.where((t) => t.selected).toList()),
    );

    final itemIds = _getUniqueItemsFromTrips(selectedTrips);
    final itemsToTakeAsync = ref.watch(itemsByIdProvider(itemIds));

    return itemsToTakeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Erreur de chargement"),
      data: (itemsToTake) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.prepare_title.tr()),
          actions: [
            IconButton(
              onPressed: () => _showSelectDialog(context, ref, allTrips),
              icon: const Icon(Icons.luggage),
              tooltip: LocaleKeys.tooltip_selectTrips.tr(),
            ),
            IconButton(
              onPressed: () => _untakeAllItems(ref),
              icon: const Icon(Icons.replay),
              tooltip: LocaleKeys.tooltip_resetItems.tr(),
            ),
          ],
        ),
        body: selectedTrips.isEmpty
            ? Center(child: Text(LocaleKeys.prepare_noTrip.tr()))
            : itemsToTake.isEmpty
            ? Center(child: Text(LocaleKeys.prepare_empty.tr()))
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
      ),
    );
  }
}
