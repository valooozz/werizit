import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rangement/core/utils/snackbar_utils.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class DatabaseImporter {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Importe les données depuis un fichier JSON au format exporté
  Future<void> importDatabaseFromJson(BuildContext context) async {
    try {
      // Choisir un fichier JSON
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        showAppSnackBar(LocaleKeys.import_noFile.tr());
        return;
      }

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final db = await _dbHelper.database;

      final batch = db.batch();

      // On vide d’abord toutes les tables existantes pour repartir propre
      for (final table in data.keys) {
        await db.delete(table);
      }

      // Réinsertion de toutes les lignes
      data.forEach((table, rows) {
        final rowList = List<Map<String, dynamic>>.from(rows);
        for (final row in rowList) {
          batch.insert(
            table,
            row,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });

      await batch.commit(noResult: true);

      showAppSnackBar(LocaleKeys.import_sucess.tr());
    } catch (e) {
      showAppSnackBar(LocaleKeys.import_error.tr(args: [e.toString()]));
    }
  }
}
