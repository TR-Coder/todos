import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/blocs/todos_bloc.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/visivility_filter.dart';

//==============================================================
// ESTATS:
//  - FilterInProgress()
//  - FilterLoaded(filteredTodos, activeFilter)
//==============================================================
abstract class FilterState {
  const FilterState();
}

class FilterInProgress extends FilterState {}

class FilterLoaded extends FilterState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;
  const FilterLoaded(this.filteredTodos, this.activeFilter);
}

//==============================================================
// ESDEVENIMENTS:
//  - FilterUpdated(visibilityFilter)
//  - TodosUpdated(todos) --> Listening TodosBloc
//==============================================================
abstract class FilterEvent {
  const FilterEvent();
}

class FilterUpdated extends FilterEvent {
  final VisibilityFilter visibilityFilter;
  const FilterUpdated(this.visibilityFilter);
}

class TodosUpdated extends FilterEvent {
  final List<Todo> todos;
  const TodosUpdated(this.todos);
}

//==============================================================
// MAP
//==============================================================
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final TodosBloc todosBloc;
  StreamSubscription<TodosState> todosBlocSubscription;

  FilterBloc({
    @required this.todosBloc,
  }) : super(initialFilterState(todosBloc)) {
    todosBlocSubscription = createTodosBlocSubscription();
  }

  static FilterState initialFilterState(TodosBloc todosBloc) {
    return (todosBloc.state is Loaded)
        ? FilterLoaded((todosBloc.state as Loaded).todos, VisibilityFilter.all)
        : FilterInProgress();
  }

  StreamSubscription<TodosState> createTodosBlocSubscription() {
    return todosBloc.stream.listen((state) {
      if (state is Load) {
        final todos = (todosBloc.state as Loaded).todos;
        add(TodosUpdated(todos));
      }
    });
  }

  @override
  Future<void> close() {
    todosBlocSubscription.cancel();
    return super.close();
  }

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
