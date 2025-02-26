import 'package:flutter/material.dart';

class DynamicOutlineTextFieldWidget extends StatelessWidget {
  final String label;

  const DynamicOutlineTextFieldWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    if (label == "") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              TextField(
                readOnly: true,
                canRequestFocus: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(label, textAlign: TextAlign.start),
            ),
            SizedBox(height: 8),
            TextField(
              readOnly: true,
              canRequestFocus: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
