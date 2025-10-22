import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rangement/data/models/item.dart';
import 'package:rangement/generated/locale_keys.g.dart';

class SelectItemsDialog extends StatefulWidget {
  final List<Item> items;

  const SelectItemsDialog({super.key, required this.items});

  @override
  State<SelectItemsDialog> createState() => _SelectItemsDialogState();
}

class _SelectItemsDialogState extends State<SelectItemsDialog> {
  final Set<int> _selectedIds = {};

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final valideButtonLabel =
        widget.items.isNotEmpty && widget.items[0].shelf == null
        ? LocaleKeys.box_drop.tr()
        : LocaleKeys.box_add.tr();
    return AlertDialog(
      title: Text(LocaleKeys.box_title.tr()),
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
              title: Text(item.name),
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
          onPressed: () => Navigator.pop(context, _selectedIds.toList()),
          child: Text(valideButtonLabel),
        ),
      ],
    );
  }
}
