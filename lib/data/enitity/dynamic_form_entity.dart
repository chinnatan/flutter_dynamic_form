import 'package:flutter_dynamic_form_poc/constants/constant.dart';

class DynamicFormEntity {
  final String id;
  String? label;
  final FormType type;
  List<DynamicFormEntity> children;

  DynamicFormEntity({
    required this.id,
    this.label,
    required this.type,
    required this.children,
  });
}
