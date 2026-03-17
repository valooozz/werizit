import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/items_provider.dart';
import 'package:werizit/core/providers/trips_provider.dart';
import 'package:werizit/generated/locale_keys.g.dart';
import 'package:werizit/presentation/widgets/cards/trip_card.dart';

class PrepareTripScreen extends ConsumerWidget {
  const PrepareTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();
    final items = ref.watch(itemsProvider).toList();

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.trips_title.tr())),
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
