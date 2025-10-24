import 'package:flutter/material.dart';
import 'package:rangement/main.dart';

void showAppSnackBar(String message, {bool isError = false}) {
  final messenger = rootScaffoldMessengerKey.currentState;
  if (messenger == null) return;
  final context = rootScaffoldMessengerKey.currentContext;
  if (context == null) return;

  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}
