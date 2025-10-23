import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun fichier sélectionné.')),
        );
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import JSON terminé avec succès !')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur lors de l’import : $e')));
    }
  }
}
