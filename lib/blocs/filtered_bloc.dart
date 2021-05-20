import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/models/todo.dart';
import 'package:todos/models/visivility_filter.dart';

//==============================================================
// ESTATS:
//  - FilterInProgress()
//  - FilterLoaded(filteredTodos, activeFilter)
//==============================================================
abstract class State {
  const State();
}

class LoadInProgress extends State {}

class Loaded extends State {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;
  const Loaded(this.filteredTodos, this.activeFilter);
}

//==============================================================
// ESDEVENIMENTS:
//  - FilterUpdated(visibilityFilter)
//  - TodosUpdated(todos) --> Listening TodosBloc
//==============================================================
abstract class Event {
  const Event();
}

class Updated extends Event {
  final VisibilityFilter visibilityFilter;
  const Updated(this.visibilityFilter);
}

class TodosUpdated extends Event {
  final List<Todo> todos;
  const TodosUpdated(this.todos);
}

//==============================================================
// MAP
//==============================================================
class Map extends Bloc<Event, State> {
  final TODOSBLOC.Map todosBloc;
  StreamSubscription<TODOSBLOC.State> todosBlocSubscription;

  Map({
    @required this.todosBloc,
  }) : super(initialFilterState(todosBloc)) {
    todosBlocSubscription = createTodosBlocSubscription();
  }

  static State initialFilterState(TODOSBLOC.Map todosBloc) {
    if (todosBloc.state is TODOSBLOC.Loaded) {
      var todos = (todosBloc.state as TODOSBLOC.Loaded).todos;
      return Loaded(todos, VisibilityFilter.all);
    }
    return LoadInProgress();
  }

  StreamSubscription<TODOSBLOC.State> createTodosBlocSubscription() {
    return todosBloc.stream.listen((state) {
      if (state is TODOSBLOC.Loaded) {
        final todos = state.todos;
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
