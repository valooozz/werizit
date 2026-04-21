abstract class StorageDraft {
  final String name;

  const StorageDraft({required this.name});

  Map<String, dynamic> toMap() => {'name': name};

  StorageDraft copyWith({String? name, int? parentId});
}
