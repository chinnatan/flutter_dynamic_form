// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_form_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicFormEntity _$DynamicFormEntityFromJson(Map<String, dynamic> json) =>
    DynamicFormEntity(
      id: json['id'] as String,
      label: json['label'] as String?,
      type: $enumDecode(_$FormTypeEnumMap, json['type']),
      children:
          (json['children'] as List<dynamic>)
              .map((e) => DynamicFormEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DynamicFormEntityToJson(DynamicFormEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': _$FormTypeEnumMap[instance.type]!,
      'children': instance.children,
    };

const _$FormTypeEnumMap = {
  FormType.outlineTextField: 'outlineTextField',
  FormType.row: 'row',
  FormType.column: 'column',
};
