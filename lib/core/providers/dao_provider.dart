import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/dao/base_dao.dart';
import 'package:rangement/data/dao/dao.dart';
import 'package:rangement/data/dao/mock_dao.dart';

final daoProvider = Provider<BaseDAO>(
  (ref) => kIsWeb || defaultTargetPlatform == TargetPlatform.windows
      ? MockDAO()
      : DAO(),
);
