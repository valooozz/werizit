import 'package:flutter/material.dart';

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final Future<void> Function(String text) onConfirm;
  final String cancelText;
  final String confirmText;

  const TextFieldDialog({
    super.key,
    required this.title,
    required this.hintText,
    required this.onConfirm,
    required this.cancelText,
    required this.confirmText,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String hintText,
    required Future<void> Function(String text) onConfirm,
    required String cancelText,
    required String confirmText,
  }) {
    return showDialog(
      context: context,
      builder: (_) => TextFieldDialog(
        title: title,
        hintText: hintText,
        onConfirm: onConfirm,
        cancelText: cancelText,
        confirmText: confirmText,
      ),
    );
  }

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: widget.hintText),
        enabled: !_isSubmitting,
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  setState(() => _isSubmitting = true);
                  Navigator.pop(context);
                  await widget.onConfirm(text);
                },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
