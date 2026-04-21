import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/core/providers/item/item_provider.dart';
import 'package:werizit/core/providers/shelf/shelf_provider.dart';
import 'package:werizit/data/models/shelf/shelf.dart';
import 'package:werizit/data/models/states/shelf_screen_state.dart';
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

final shelfScreenProvider = Provider.family<AsyncValue<ShelfScreenState>, int>((
  ref,
  shelfId,
) {
  final shelfAsync = ref.watch(shelfByIdProvider(shelfId));
  final itemsAsync = ref.watch(itemProvider);

  if (shelfAsync.isLoading || itemsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (shelfAsync.hasError) {
    return AsyncError(shelfAsync.error!, shelfAsync.stackTrace!);
  }
  if (itemsAsync.hasError) {
    return AsyncError(itemsAsync.error!, itemsAsync.stackTrace!);
  }

  final shelf = shelfAsync.value!;
  final itemsMap = itemsAsync.value!;

  final items = itemsMap.values;

  final shelfItems = items.where((i) => i.shelf == shelf.id).toList();

  final boxItems = items.where((i) => i.shelf == -1).toList();

  return AsyncData(
    ShelfScreenState(shelf: shelf, shelfItems: shelfItems, boxItems: boxItems),
  );
});
