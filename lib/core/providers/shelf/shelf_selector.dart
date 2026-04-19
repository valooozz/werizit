import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/shelf/shelf_provider.dart';
import 'package:werizit/data/models/shelf.dart';
import 'package:werizit/generated/locale_keys.g.dart';

final shelfByIdProvider = Provider.family<AsyncValue<Shelf>, int>((ref, id) {
  final shelvesAsync = ref.watch(shelfProvider);

  return shelvesAsync.whenData((shelves) {
    final shelf = shelves[id];
    if (shelf == null) {
      return Shelf(id: -2, name: LocaleKeys.wardrobe_title.tr(), furniture: -1);
    }
    return shelf;
  });
});

final shelvesByFurnitureProvider = Provider.family<List<Shelf>, int>((
  ref,
  furnitureId,
) {
  final shelfs = ref.watch(shelfProvider).valueOrNull ?? {};

  return shelfs.values.where((r) => r.furniture == furnitureId).toList();
});
