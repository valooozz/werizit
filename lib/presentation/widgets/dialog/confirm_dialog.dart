import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werizit/generated/locale_keys.g.dart';

class ConfirmDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelLabel ?? LocaleKeys.common_cancel.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmLabel ?? LocaleKeys.common_confirm.tr()),
            ),
          ],
        );
      },
    );
  }
}
