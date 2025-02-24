part of 'dynamic_form_bloc.dart';

sealed class DynamicFormEvent {}

class AddWidgetEvent extends DynamicFormEvent {
  final DynamicFormEntity newWidget;

  AddWidgetEvent(this.newWidget);
}

class RemoveWidgetEvent extends DynamicFormEvent {
  final DynamicFormEntity removeWidget;
  List<DynamicFormEntity> listParentWidget;

  RemoveWidgetEvent(this.removeWidget, this.listParentWidget);
}
