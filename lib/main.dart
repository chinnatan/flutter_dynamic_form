import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form_poc/components/dynamic_outline_text_field.dart';
import 'package:flutter_dynamic_form_poc/constants/constant.dart';
import 'package:flutter_dynamic_form_poc/data/enitity/dynamic_form_entity.dart';

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

  List<DynamicFormEntity> dynamicFormEntities = [];

  void addWidget(DynamicFormEntity widgetData) {
    setState(() {
      dynamicFormEntities.add(widgetData);
    });
  }

  void removeWidget(
    DynamicFormEntity widgetData,
    List<DynamicFormEntity> parentList,
  ) {
    setState(() {
      parentList.remove(widgetData);
    });
  }

  String exportToJson() {
    return jsonEncode(formWidgets);
  }

  void loadFromJson(String jsonString) {
    setState(() {
      formWidgets =
          (jsonDecode(jsonString) as List<dynamic>)
              .cast<Map<String, dynamic>>();
    });
  }

  Widget buildFormWidget(
    DynamicFormEntity data,
    List<DynamicFormEntity> parentList,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0), // กันที่ให้ปุ่มลบ
            child: _buildWidgetType(data, parentList),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: () => removeWidget(data, parentList),
        ),
      ],
    );
  }

  Widget _buildWidgetType(
    DynamicFormEntity data,
    List<DynamicFormEntity> parentList,
  ) {
    switch (data.type) {
      case FormType.outlineTextField:
        return DynamicOutlineTextFieldWidget(label: data.label ?? '');
      case FormType.row:
        return _buildDropZone(
          type: 'Row',
          data: data,
          parentList: parentList,
          child: Row(
            children: [
              ...data.children.map<Widget>(
                (child) => buildFormWidget(child, data.children),
              ),
            ],
          ),
        );
      case FormType.column:
        return Container(); // Add appropriate widget here
    }
  }

  Widget _buildDropZone({
    required String type,
    required DynamicFormEntity data,
    required List<DynamicFormEntity> parentList,
    required Widget child,
  }) {
    return DragTarget<DynamicFormEntity>(
      onAcceptWithDetails: (details) {
        setState(() {
          data.children.add(details.data);
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.withValues(alpha: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "วางตรงนี้ ($type)",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              type == "Row"
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        data.children
                            .map<Widget>(
                              (child) => Expanded(
                                child: buildFormWidget(child, data.children),
                              ),
                            )
                            .toList(),
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data.children
                            .map<Widget>(
                              (child) => buildFormWidget(child, data.children),
                            )
                            .toList(),
                  ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildDropZone({
  //   required String type,
  //   required Map<String, dynamic> data,
  //   required List<Map<String, dynamic>> parentList,
  //   required Widget child,
  // }) {
  //   return DragTarget<Map<String, dynamic>>(
  //     onAcceptWithDetails: (details) {
  //       setState(() {
  //         if (data['children'] == null) {
  //           data['children'] = [];
  //         }
  //         (data['children'] as List).add(details.data);
  //       });
  //     },
  //     builder: (context, candidateData, rejectedData) {
  //       List<Map<String, dynamic>> children = [];
  //       if (data['children'] != null) {
  //         children =
  //             (data['children'] as List).map((item) {
  //               if (item is Map) {
  //                 return Map<String, dynamic>.from(item);
  //               }
  //               return <String, dynamic>{};
  //             }).toList();
  //       }
  //       return Container(
  //         padding: EdgeInsets.all(5),
  //         margin: EdgeInsets.symmetric(vertical: 5),
  //         decoration: BoxDecoration(
  //           border: Border.all(color: Colors.blue, width: 2),
  //           borderRadius: BorderRadius.circular(8),
  //           color: Colors.blue.withOpacity(0.1),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Center(
  //               child: Text(
  //                 "Drop here ($type)",
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             type == "Row"
  //                 ? Row(
  //                   mainAxisSize:
  //                       MainAxisSize.min, // ✅ ป้องกัน Row ขยายใหญ่ผิดปกติ
  //                   children:
  //                       children
  //                           .map<Widget>(
  //                             (child) => buildFormWidget(child, children),
  //                           )
  //                           .toList(),
  //                 )
  //                 : Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children:
  //                       children
  //                           .map<Widget>(
  //                             (child) => buildFormWidget(child, children),
  //                           )
  //                           .toList(),
  //                 ),
  //           ],
  //         ),
  //       );
  //     },
  //   );

  Widget _draggableButton(DynamicFormEntity data) {
    switch (data.type) {
      case FormType.outlineTextField:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Draggable<DynamicFormEntity>(
            data: data,
            feedback: _draggingWidget(
              data.label ?? FormType.outlineTextField.name,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Text Field"),
                    SizedBox(height: 8),
                    DynamicOutlineTextFieldWidget(label: ''),
                  ],
                ),
              ),
            ),
          ),
        );
      case FormType.row:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Draggable<DynamicFormEntity>(
            data: data,
            feedback: _draggingWidget(
              data.label ?? FormType.outlineTextField.name,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [Text("Row")]),
              ),
            ),
          ),
        );
      case FormType.column:
        break;
    }
    return SizedBox.shrink();
  }

  Widget _draggingWidget(String label) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue,
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Form Builder")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sidebar: Drag Sources
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _draggableButton(
                    DynamicFormEntity(
                      id: UniqueKey().toString(),
                      type: FormType.outlineTextField,
                      children: [],
                    ),
                  ),
                  _draggableButton(
                    DynamicFormEntity(
                      id: UniqueKey().toString(),
                      type: FormType.row,
                      children: [],
                    ),
                  ),
                  // _draggableButton("Dropdown"),
                  // _draggableButton("Checkbox"),
                  // _draggableButton("Row"),
                  // _draggableButton("Column"),
                  ElevatedButton(
                    onPressed: () {
                      print(exportToJson());
                    },
                    child: Text("Export JSON"),
                  ),
                ],
              ),
            ),

            // Main form area: DragTarget
            Expanded(
              flex: 2,
              child: DragTarget<DynamicFormEntity>(
                onAcceptWithDetails: (details) {
                  addWidget(details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      children:
                          dynamicFormEntities.isEmpty
                              ? [
                                Text(
                                  "ลาก Widget มาวางที่นี่",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ]
                              : dynamicFormEntities
                                  .map(
                                    (w) =>
                                        buildFormWidget(w, dynamicFormEntities),
                                  )
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
