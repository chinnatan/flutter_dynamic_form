part of 'dynamic_form_bloc.dart';

sealed class DynamicFormState {}

final class DynamicFormInitial extends DynamicFormState {}

class AddedWidgetState extends DynamicFormState {
  AddedWidgetState();
}

class RemovedWidgetState extends DynamicFormState {
  RemovedWidgetState();
}
