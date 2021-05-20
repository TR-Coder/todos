//==============================================================
// ESTATS:
//  - LoadInProgress()
//  - Loaded(todos)
//==============================================================
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/models/todo.dart';

abstract class State {
  const State();
}

class LoadInProgress extends State {}

class Loaded extends State {
  final int numActive;
  final int numCompleted;
  const Loaded(this.numActive, this.numCompleted);
}

//==============================================================
// ESDEVENIMENTS:
//  - TodosChanged()
//==============================================================
abstract class Event {
  const Event();
}

class StatsChanged extends Event {
  final List<Todo> todos;
  const StatsChanged(this.todos);
}

//==============================================================
// MAP
//==============================================================xs
class Map extends Bloc<Event, State> {
  final TODOSBLOC.Map todosBloc;
  StreamSubscription<TODOSBLOC.State> todosBlocSubscription;
  Map({
    @required this.todosBloc,
  }) : super(LoadInProgress()) {
    todosBlocSubscription = createTodosBlocSubscription();
  }

  StreamSubscription<TODOSBLOC.State> createTodosBlocSubscription() {
    return todosBloc.stream.listen((state) {
      if (state is TODOSBLOC.Loaded) {
        final todos = (todosBloc.state as TODOSBLOC.Loaded).todos;
        add(StatsChanged(todos));
      }
    });
  }

  @override
  Stream<State> mapEventToState(Event event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
