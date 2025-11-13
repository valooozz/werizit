// lib/data/db/database_exporter.dart
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import 'database_helper.dart';

class DatabaseExporter {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Exporte toute la base SQLite en un fichier JSON partageable
  Future<void> exportDatabaseAsJson(BuildContext context) async {
    try {
      final db = await _dbHelper.database;

      // Liste des tables à exporter (hors tables système)
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
      );

      Map<String, dynamic> exportData = {};

      for (var table in tables) {
        final tableName = table['name'] as String;
        final rows = await db.query(tableName);
        exportData[tableName] = rows;
      }

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = join(directory.path, 'storage_export.json');
      final file = File(filePath);
      await file.writeAsString(jsonString);

      final params = ShareParams(
        text: 'Export de la base de données',
        files: [XFile(file.path)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        showAppSnackBar(LocaleKeys.export_success.tr());
      } else {
        showAppSnackBar(LocaleKeys.export_created.tr());
      }
    } catch (e) {
      showAppSnackBar(LocaleKeys.export_error.tr(args: [e.toString()]));
    }
  }
}
