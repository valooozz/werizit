import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rangement/core/icons/box_icons.dart';
import 'package:rangement/generated/locale_keys.g.dart';
import 'package:rangement/presentation/widgets/dialog/confirm_dialog.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final VoidCallback? onAdd;
  final VoidCallback? onSearch;
  final VoidCallback? onHandleTrips;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;
  final VoidCallback? onAddToBox;
  final VoidCallback? onDropFromBox;
  final VoidCallback? onBack;
  final String? deleteConfirmationTitle;
  final String? deleteConfirmationMessage;
  final bool showHome;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.onAdd,
    this.onSearch,
    this.onHandleTrips,
    this.onDelete,
    this.onRename,
    this.onAddToBox,
    this.onDropFromBox,
    this.onBack,
    this.deleteConfirmationTitle,
    this.deleteConfirmationMessage,
    this.showHome = true,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  void _delete() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title:
          widget.deleteConfirmationTitle ??
          LocaleKeys.common_confirm_delete.tr(args: [widget.title]),
      message:
          widget.deleteConfirmationMessage ??
          LocaleKeys.storage_delete_warning.tr(),
    );

    if (confirmed != true || !mounted) return;

    widget.onDelete!();
  }

  void _navigateToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                tooltip: LocaleKeys.tooltip_back.tr(),
              )
            : null,
        title: Text(widget.title),
        actions: [
          if (widget.showHome == true)
            IconButton(
              onPressed: _navigateToHome,
              icon: const Icon(Icons.home),
              tooltip: LocaleKeys.tooltip_home.tr(),
            ),
          if (widget.onHandleTrips != null)
            IconButton(
              onPressed: widget.onHandleTrips,
              icon: const Icon(Icons.trip_origin),
              tooltip: LocaleKeys.tooltip_openTrips.tr(),
            ),
          if (widget.onSearch != null)
            IconButton(
              onPressed: widget.onSearch,
              icon: const Icon(Icons.search),
              tooltip: LocaleKeys.tooltip_search.tr(),
            ),
          if (widget.onAddToBox != null)
            IconButton(
              onPressed: widget.onAddToBox,
              icon: const Icon(BoxIcons.boxAdd),
              tooltip: LocaleKeys.tooltip_addToBox.tr(),
            ),
          if (widget.onDropFromBox != null)
            IconButton(
              onPressed: widget.onDropFromBox,
              icon: const Icon(BoxIcons.box),
              tooltip: LocaleKeys.tooltip_dropFromBox.tr(),
            ),
          if (widget.onRename != null)
            IconButton(
              onPressed: widget.onRename,
              icon: const Icon(Icons.edit),
              tooltip: LocaleKeys.tooltip_edit.tr(),
            ),
          if (widget.onDelete != null)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete),
              tooltip: LocaleKeys.tooltip_delete.tr(),
            ),
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
