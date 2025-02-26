import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_form_poc/data/enitity/dynamic_form_entity.dart';
import 'package:uuid/v4.dart';

part 'dynamic_form_event.dart';
part 'dynamic_form_state.dart';

class DynamicFormBloc extends Bloc<DynamicFormEvent, DynamicFormState> {
  List<DynamicFormEntity> widgets = [];

  DynamicFormBloc() : super(DynamicFormInitial()) {
    on<AddWidgetEvent>((event, emit) {
      event.newWidget.id = UuidV4().generate();

      final newWidget = DynamicFormEntity(
        id: UuidV4().generate(),
        label: event.newWidget.label,
        type: event.newWidget.type,
        children: [],
      );

      widgets.add(newWidget);
      emit(AddedWidgetState());
    });

    on<AddChildWidgetEvent>((event, emit) {
      event.parentWidget.children.add(event.newChildrenWidget);
      emit(AddedWidgetState());
    });

    on<RemoveWidgetEvent>((event, emit) {
      event.listParentWidget.remove(event.removeWidget);
      emit(RemovedWidgetState());
    });
  }
}
