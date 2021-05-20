import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/models/todo.dart';
import 'package:todos/models/visivility_filter.dart';

//==============================================================
// ESTATS:
//  - Loading()
//  - Loaded(filteredTodos, activeFilter)
//==============================================================
abstract class State {
  const State();
}

class Loading extends State {}

class Loaded extends State {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;
  const Loaded(this.filteredTodos, this.activeFilter);
}

//==============================================================
// ESDEVENIMENTS:
//  - Updated(visibilityFilter)
//  - TodosChanged(todos) --> Listening TodosBloc
//==============================================================
abstract class Event {
  const Event();
}

class Updated extends Event {
  final VisibilityFilter visibilityFilter;
  const Updated(this.visibilityFilter);
}

class TodosChanged extends Event {
  final List<Todo> todos;
  const TodosChanged(this.todos);
}

//==============================================================
// MAP
//==============================================================
class FilteredBloc extends Bloc<Event, State> {
  final TODOSBLOC.TodosBloc todosBloc;
  StreamSubscription<TODOSBLOC.State> todosBlocSubscription;

  FilteredBloc({
    @required this.todosBloc,
  }) : super(initialFilterState(todosBloc)) {
    todosBlocSubscription = createTodosBlocSubscription();
  }

  static State initialFilterState(TODOSBLOC.TodosBloc todosBloc) {
    if (todosBloc.state is TODOSBLOC.Loaded) {
      var todos = (todosBloc.state as TODOSBLOC.Loaded).todos;
      return Loaded(todos, VisibilityFilter.all);
    }
    return Loading();
  }

  StreamSubscription<TODOSBLOC.State> createTodosBlocSubscription() {
    return todosBloc.stream.listen((state) {
      if (state is TODOSBLOC.Loaded) {
        add(TodosChanged(state.todos));
      }
    });
  }

  @override
  Future<void> close() {
    todosBlocSubscription.cancel();
    return super.close();
  }

  @override
  Stream<State> mapEventToState(Event event) async* {
    if (event is Updated)
      yield* _mapUpdated(event.visibilityFilter);
    else if (event is TodosChanged) {
      yield* _mapTodosChanged(event.todos);
    }
  }

  Stream<State> _mapUpdated(VisibilityFilter visibilityFilter) async* {
    if (todosBloc.state is TODOSBLOC.Loaded) {
      final completeList = (state as TODOSBLOC.Loaded).todos;
      List<Todo> filteredTodos = filterTodos(completeList, visibilityFilter);
      yield Loaded(filteredTodos, visibilityFilter);
    }
  }

  Stream<State> _mapTodosChanged(List<Todo> todos) async* {
    final VisibilityFilter visibilityFilter = (state is Loaded) ? (state as Loaded).activeFilter : VisibilityFilter.all;
    List<Todo> filteredTodos = filterTodos(todos, visibilityFilter);
    yield Loaded(filteredTodos, visibilityFilter);
  }

  List<Todo> filterTodos(List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) return true;
      if (filter == VisibilityFilter.active) return !todo.complete;
      return todo.complete;
    }).toList();
  }
}
