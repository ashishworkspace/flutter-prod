import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TaskEvent {}

class AddTaskEvent extends TaskEvent {}

class TaskState {
  DateTime date;
  TaskState({required this.date});
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskState(date: DateTime.now())) {
    on<AddTaskEvent>(
      (event, emit) => emit(TaskState(date: state.date)),
    );
  }
}
