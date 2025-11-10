import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/models/thing.dart';
import 'package:rangement/generated/locale_keys.g.dart';

class SelectItemsDialog<T extends Thing> extends StatefulWidget {
  final List<T> items;
  final String validButtonLabel;
  final Set<int>? startSelectedIds;

  const SelectItemsDialog({
    super.key,
    required this.items,
    required this.validButtonLabel,
    this.startSelectedIds,
  });

  @override
  State<SelectItemsDialog> createState() => _SelectItemsDialogState();
}

class _SelectItemsDialogState<T extends Thing>
    extends State<SelectItemsDialog<T>> {
  late final Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.startSelectedIds != null
        ? Set<int>.from(widget.startSelectedIds!)
        : <int>{};
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == widget.items.length) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(widget.items.map((e) => e.id!).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = _selectedIds.length == widget.items.length;

    return AlertDialog(
      titlePadding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 8,
        bottom: 8,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              LocaleKeys.box_title.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: _toggleSelectAll,
            icon: allSelected
                ? const Icon(Icons.deselect)
                : const Icon(Icons.select_all),
            tooltip: allSelected
                ? LocaleKeys.tooltip_unselect.tr()
                : LocaleKeys.tooltip_select.tr(),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = _selectedIds.contains(item.id);
            return CheckboxListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              value: isSelected,
              onChanged: (_) => _toggleSelection(item.id!),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: _selectedIds.isEmpty
              ? null
              : () => Navigator.pop(context, _selectedIds.toList()),
          child: Text(widget.validButtonLabel),
        ),
      ],
    );
  }
}
