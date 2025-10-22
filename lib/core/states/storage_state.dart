import 'package:rangement/data/models/storage.dart';

class StorageState {
  final List<Storage> insideStorages;
  final String storageName;

  StorageState({required this.insideStorages, required this.storageName});

  StorageState copyWith({List<Storage>? insideStorages, String? storageName}) {
    return StorageState(
      insideStorages: insideStorages ?? this.insideStorages,
      storageName: storageName ?? this.storageName,
    );
  }
}
