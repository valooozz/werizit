import 'package:werizit/data/models/storage/storage_draft.dart';

class HouseDraft extends StorageDraft {
  const HouseDraft({required super.name});

  factory HouseDraft.fromMap(Map<String, dynamic> map) =>
      HouseDraft(name: map['name']);

  @override
  HouseDraft copyWith({String? name, int? parentId}) {
    return HouseDraft(name: name ?? this.name);
  }
}
