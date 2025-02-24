import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_form_poc/bloc/dynamic_form_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<DynamicFormBloc>(create: (context) => DynamicFormBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: const DynamicFormBuilder(),
      ),
    );
  }
}

class DynamicFormBuilder extends StatefulWidget {
  const DynamicFormBuilder({super.key});

  @override
  _DynamicFormBuilderState createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  List<DynamicFormEntity> dynamicFormEntities = [];

  String exportToJson() {
    return jsonEncode(context.read<DynamicFormBloc>().widgets);
  }

  // void loadFromJson(String jsonString) {
  //   setState(() {
  //     formWidgets =
  //         (jsonDecode(jsonString) as List<dynamic>)
  //             .cast<Map<String, dynamic>>();
  //   });
  // }

  Widget buildFormWidget(
    DynamicFormEntity data,
    List<DynamicFormEntity> parentList,
  ) {
    return Row(
      children: [
        Expanded(child: _buildWidgetType(data, parentList)),
        IconButton(
          icon: Icon(Icons.cancel, color: Colors.red),
          onPressed:
              () => context.read<DynamicFormBloc>().add(
                RemoveWidgetEvent(data, parentList),
              ),
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
          type: FormType.row.name,
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
        return _buildDropZone(
          type: FormType.column.name,
          data: data,
          parentList: parentList,
          child: Column(
            children: [
              ...data.children.map<Widget>(
                (child) => buildFormWidget(child, data.children),
              ),
            ],
          ),
        );
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
        if (data.type == FormType.row && data.children.length < 3) {
          context.read<DynamicFormBloc>().add(
            AddChildWidgetEvent(data, details.data),
          );
        } else if (data.type == FormType.column) {
          context.read<DynamicFormBloc>().add(
            AddChildWidgetEvent(data, details.data),
          );
        }
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
                  type == FormType.row.name
                      ? "วางตรงนี้ ($type ใส่ได้สูงสุด 3 ตัว)"
                      : "วางตรงนี้ ($type)",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              type == FormType.row.name
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
                    mainAxisSize: MainAxisSize.min,
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
            feedback: _draggingWidget(data.label ?? FormType.row.name),
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Draggable<DynamicFormEntity>(
            data: data,
            feedback: _draggingWidget(data.label ?? FormType.column.name),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [Text("Column")]),
              ),
            ),
          ),
        );
    }
    // return SizedBox.shrink();
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
                  _draggableButton(
                    DynamicFormEntity(
                      id: UniqueKey().toString(),
                      type: FormType.column,
                      children: [],
                    ),
                  ),
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
                  // addWidget(details.data);
                  context.read<DynamicFormBloc>().add(
                    AddWidgetEvent(details.data),
                  );
                },
                builder: (context, candidateData, rejectedData) {
                  return BlocBuilder<DynamicFormBloc, DynamicFormState>(
                    builder: (context, state) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children:
                              context.read<DynamicFormBloc>().widgets.isEmpty
                                  ? [
                                    Text(
                                      "ลาก Widget มาวางที่นี่",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ]
                                  : context
                                      .read<DynamicFormBloc>()
                                      .widgets
                                      .map(
                                        (w) => buildFormWidget(
                                          w,
                                          context
                                              .read<DynamicFormBloc>()
                                              .widgets,
                                        ),
                                      )
                                      .toList(),
                        ),
                      );
                    },
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
