import 'package:flutter/material.dart';

class DynamicOutlineTextFieldWidget extends StatelessWidget {
  final String label;

  const DynamicOutlineTextFieldWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          readOnly: true,
          canRequestFocus: false,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
