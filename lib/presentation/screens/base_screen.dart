import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onAdd;
  final VoidCallback? onSearch;
  final VoidCallback? onDelete;
  final VoidCallback? onBack;

  const BaseScreen({
    super.key,
    required this.title,
    required this.body,
    this.onAdd,
    this.onSearch,
    this.onDelete,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onBack != null
            ? IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back))
            : null,
        title: Text(title),
        actions: [
          if (onSearch != null)
            IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
          if (onDelete != null)
            IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: body,
      floatingActionButton: onAdd != null
          ? FloatingActionButton(onPressed: onAdd, child: const Icon(Icons.add))
          : null,
    );
  }
}
