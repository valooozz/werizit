import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/items_provider.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/data/models/trip.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/cards/trip_card.dart';
import 'package:werizit/presentation/widgets/dialog/select_dialog.dart';

class PrepareTripScreen extends ConsumerWidget {
  const PrepareTripScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();
    final items = ref.watch(itemsProvider).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.prepare_title.tr()),
        actions: [
          IconButton(
            onPressed: () => _showSelectDialog(context, ref, trips),
            icon: const Icon(Icons.luggage),
            tooltip: LocaleKeys.tooltip_selectTrips.tr(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: trips.isEmpty
            ? Center(child: Text(LocaleKeys.trips_noTrip.tr()))
            : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TripCard(trip: trip),
                  );
                },
              ),
      ),
    );
  }
}
