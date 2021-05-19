//==============================================================
// ESTATS
//==============================================================
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todos_repositori.dart';

abstract class TodosState {
  TodosState();
}

class LoadInProgress extends TodosState {}

class LoadSuccess extends TodosState {
  final List<Todo> todos;
  LoadSuccess({@required this.todos});
}

class LoadFailure extends TodosState {}

//==============================================================
// ESDEVENIMENTS
//==============================================================
abstract class TodosEvent {
  TodosEvent();
}

class Load extends TodosEvent {}

class Add extends TodosEvent {
  final Todo todo;
  Add(this.todo);
}

class Update extends TodosEvent {
  final Todo todo;
  Update(this.todo);
}

class Delete extends TodosEvent {
  final Todo todo;
  Delete(this.todo);
}

class ClearCompleted extends TodosEvent {}

class ToggeAll extends TodosEvent {}

//==============================================================
// MAP
//==============================================================

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository todosRepositoy;

  TodosBloc({
    @required this.todosRepositoy,
  }) : super(LoadInProgress());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is LoadSuccess) yield* _mapLoadSuccess();
  }
}

Stream<TodosState> _mapLoadSuccess() async* {
  try {
    final todos = await todosRepositoy.loadTodos();
    yield LoadSuccess();
  } catch (_) {
    yield LoadFailure();
  }
}
