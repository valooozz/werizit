import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/trips_provider.dart';
import 'package:rangement/generated/locale_keys.g.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();

    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.search_title.tr())),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: trips.isEmpty
            ? Center(child: Text(LocaleKeys.search_noItem.tr()))
            : Expanded(
                child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];

                    return Placeholder(); // ICI METTRE UNE TripCard
                  },
                ),
              ),
      ),
    );
  }
}
