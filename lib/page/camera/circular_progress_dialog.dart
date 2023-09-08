import 'package:flutter/material.dart';

class CircularProgressDialog extends StatefulWidget {
  const CircularProgressDialog({super.key});

  @override
  State<CircularProgressDialog> createState() => _CircularProgressDialogState();
}

class _CircularProgressDialogState extends State<CircularProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      );
  }
}