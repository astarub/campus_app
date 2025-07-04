import 'package:flutter/material.dart';

class AddEventFab extends StatelessWidget {
  const AddEventFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Add Event',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      );
}
