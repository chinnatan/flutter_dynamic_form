import 'package:flutter_dynamic_form_poc/constants/constant.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dynamic_form_entity.g.dart';

@JsonSerializable()
class DynamicFormEntity {
  String id;
  String? label;
  final FormType type;
  List<DynamicFormEntity> children = [];

  DynamicFormEntity({
    required this.id,
    this.label,
    required this.type,
    required this.children,
  });

  factory DynamicFormEntity.fromJson(Map<String, dynamic> json) =>
      _$DynamicFormEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DynamicFormEntityToJson(this);
}
