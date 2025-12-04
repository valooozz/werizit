import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:werizit/data/dao/base_dao.dart';
import 'package:werizit/data/dao/dao.dart';
import 'package:werizit/data/dao/mock_dao.dart';

final daoProvider = Provider<BaseDAO>((ref) => kIsWeb ? MockDAO() : DAO());
