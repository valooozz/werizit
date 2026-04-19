import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/shelf/shelf_provider.dart';
import 'package:werizit/data/models/shelf.dart';
import 'package:werizit/generated/locale_keys.g.dart';

final shelfByIdProvider = Provider.family<Shelf, int>((ref, id) {
  final shelfs = ref.watch(shelfProvider).valueOrNull;
  return shelfs?[id] ??
      Shelf(id: -2, name: LocaleKeys.wardrobe_title.tr(), furniture: -1);
});

final shelvesByFurnitureProvider = Provider.family<List<Shelf>, int>((
  ref,
  furnitureId,
) {
  final shelfs = ref.watch(shelfProvider).valueOrNull ?? {};

  return shelfs.values.where((r) => r.furniture == furnitureId).toList();
});
