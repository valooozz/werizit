import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/core/providers/trips_provider.dart';
import 'package:rangement/data/models/thing.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/select_items_dialog.dart';

class SelectTripsDialog<T extends Thing> extends ConsumerWidget {
  const SelectTripsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider).toList();

    return SelectItemsDialog(
      items: trips,
      validButtonLabel: LocaleKeys.trips_link.tr(),
    );
  }
}
