import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/confirm_dialog.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final VoidCallback? onAdd;
  final VoidCallback? onSearch;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;
  final VoidCallback? onAddToBox;
  final VoidCallback? onDropFromBox;
  final VoidCallback? onBack;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.onAdd,
    this.onSearch,
    this.onDelete,
    this.onRename,
    this.onAddToBox,
    this.onDropFromBox,
    this.onBack,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  void _delete() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: LocaleKeys.common_confirm_delete.tr(args: [widget.title]),
      message: LocaleKeys.storage_delete_warning.tr(),
    );

    if (confirmed != true || !mounted) return;

    widget.onDelete!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(widget.title),
        actions: [
          if (widget.onSearch != null)
            IconButton(
              onPressed: widget.onSearch,
              icon: const Icon(Icons.search),
            ),
          if (widget.onAddToBox != null)
            IconButton(
              onPressed: widget.onAddToBox,
              icon: const Icon(Icons.move_to_inbox),
            ),
          if (widget.onDropFromBox != null)
            IconButton(
              onPressed: widget.onDropFromBox,
              icon: const Icon(Icons.outbox),
            ),
          if (widget.onRename != null)
            IconButton(
              onPressed: widget.onRename,
              icon: const Icon(Icons.edit),
            ),
          if (widget.onDelete != null)
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: widget.body,
      floatingActionButton: widget.onAdd != null
          ? FloatingActionButton(
              onPressed: widget.onAdd,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
