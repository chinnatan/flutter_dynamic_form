import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_form_poc/data/enitity/dynamic_form_entity.dart';

part 'dynamic_form_event.dart';
part 'dynamic_form_state.dart';

class DynamicFormBloc extends Bloc<DynamicFormEvent, DynamicFormState> {
  List<DynamicFormEntity> widgets = [];

  DynamicFormBloc() : super(DynamicFormInitial()) {
    on<AddWidgetEvent>((event, emit) {
      widgets.add(event.newWidget);
      emit(AddedWidgetState());
    });

    on<RemoveWidgetEvent>((event, emit) {
      event.listParentWidget.remove(event.removeWidget);
      emit(RemovedWidgetState());
    });
  }
}
