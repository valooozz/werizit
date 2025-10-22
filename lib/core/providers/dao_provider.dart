import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rangement/data/db/base_dao.dart';
import 'package:rangement/data/db/dao.dart';
import 'package:rangement/data/db/mock_dao.dart';

final daoProvider = Provider<BaseDAO>((ref) => kIsWeb ? MockDAO() : DAO());
