import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/models/todo.dart';

//==============================================================
// ESTATS:
//  - Loading()
//  - Loaded(todos)
//==============================================================

abstract class State {
  const State();
}

class Loading extends State {}

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

class Load extends Event {
  final List<Todo> todos;
  const Load(this.todos);
}

//==============================================================
// MAP
//==============================================================
class Map extends Bloc<Event, State> {
  final TODOSBLOC.TodosBloc todosBloc;
  StreamSubscription<TODOSBLOC.State> todosBlocSubscription;
  Map({
    @required this.todosBloc,
  }) : super(Loading()) {
    todosBlocSubscription = createTodosBlocSubscription();
  }

  StreamSubscription<TODOSBLOC.State> createTodosBlocSubscription() {
    return todosBloc.stream.listen((state) {
      if (state is TODOSBLOC.Loaded) {
        final todos = (todosBloc.state as TODOSBLOC.Loaded).todos;
        add(Load(todos));
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
    if (event is Load) {
      int numActive = event.todos.where((todo) => !todo.complete).toList().length;
      int numCompleted = event.todos.where((todo) => todo.complete).toList().length;
      yield Loaded(numActive, numCompleted);
    }
  }
}
