import 'package:flutter/material.dart';

class CalendarErrorMessage extends StatelessWidget {
  final String message;

  const CalendarErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error,
          size: 50,
          color: Colors.redAccent,
        ),
        const SizedBox(
          height: 20,
        ),
        DefaultTextStyle(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          child: Text(message),
        ),
      ],
    );
  }
}
