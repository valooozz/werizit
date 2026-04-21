import 'package:werizit/data/models/storage/storage_draft.dart';

class ShelfDraft extends StorageDraft {
  final int furniture;
  const ShelfDraft({required super.name, required this.furniture});

  factory ShelfDraft.fromMap(Map<String, dynamic> map) =>
      ShelfDraft(name: map['name'], furniture: map['furniture']);

  @override
  Map<String, dynamic> toMap() => {...super.toMap(), 'furniture': furniture};

  @override
  ShelfDraft copyWith({String? name, int? parentId}) {
    return ShelfDraft(
      name: name ?? this.name,
      furniture: parentId ?? furniture,
    );
  }
}
