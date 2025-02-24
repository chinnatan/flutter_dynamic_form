import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form_poc/constants/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const DynamicFormBuilder(),
    );
  }
}

class DynamicFormBuilder extends StatefulWidget {
  const DynamicFormBuilder({super.key});

  @override
  _DynamicFormBuilderState createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  List<Map<String, dynamic>> formWidgets = [];

  void addWidget(Map<String, dynamic> data) {
    setState(() {
      formWidgets.add(data);
    });
  }

  Widget buildFormWidget(Map<String, dynamic> data) {
    switch (data['type']) {
      case FormType.textField:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelText: data['label'],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _draggableButton(String type) {
    switch (type) {
      case FormType.textField:
        return Padding(
          padding: EdgeInsets.all(8),
          child: Draggable<Map<String, dynamic>>(
            data: {'type': type, 'label': FormType.textField, 'children': []},
            feedback: _draggingWidget(type),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlue),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Text Field"),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      canRequestFocus: false,
                      decoration: InputDecoration(
                        labelText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case FormType.row:
        return Padding(
          padding: EdgeInsets.all(8),
          child: Draggable<Map<String, dynamic>>(
            data: {'type': type, 'label': FormType.row, 'children': []},
            feedback: _draggingWidget(type),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlue),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Text Field"),
                    SizedBox(height: 10),
                    TextField(
                      readOnly: true,
                      canRequestFocus: false,
                      decoration: InputDecoration(
                        labelText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _draggingWidget(String type) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue,
        child: Text(type, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDropZone({
    required String type,
    required Map<String, dynamic> data,
    required Widget child,
  }) {
    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) {
        setState(() {
          data['children'].add(details.data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Drop here ($type)",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...data['children']
                  .map<Widget>((child) => buildFormWidget(child))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("สร้างฟอร์ม Inspection")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(children: [_draggableButton(FormType.textField)]),
            ),
            Expanded(
              flex: 5,
              child: DragTarget<Map<String, dynamic>>(
                onAcceptWithDetails: (details) {
                  addWidget(details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.lightBlue),
                    ),
                    child: Column(
                      children:
                          formWidgets.isEmpty
                              ? [
                                Text(
                                  "ลาก Widget มาวางที่นี่",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]
                              : formWidgets
                                  .map((w) => buildFormWidget(w))
                                  .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
