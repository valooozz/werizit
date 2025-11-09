import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/trips_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/data/models/trip.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/cards/trip_card.dart';
import 'package:rangement/presentation/widgets/dialog/text_field_dialog.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  Future<void> _addItem(WidgetRef ref, String name) async {
    await ref.read(tripsProvider.notifier).addTrip(Trip(name: name));
    showAppSnackBar(LocaleKeys.trips_added.tr());
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    TextFieldDialog.show(
      context,
      title: LocaleKeys.trips_add.tr(),
      hintText: LocaleKeys.common_name.tr(),
      cancelText: LocaleKeys.common_cancel.tr(),
      confirmText: LocaleKeys.common_add.tr(),
      onConfirm: (String name) => _addItem(ref, name),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
