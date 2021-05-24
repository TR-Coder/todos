import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todos_repository.dart';

//==============================================================
// ESTATS:
//  - Loading()
//  - Loaded(todos)
//  - LoadError()
//==============================================================
abstract class State {
  State();
}

class Loading extends State {}

class Loaded extends State {
  final List<Todo> todos;
  Loaded(this.todos);
}

class LoadError extends State {}

//==============================================================
// ESDEVENIMENTS:
//  - Load()
//  - Add(todo)
//  - Update(todo)
//  - Delete(todo)
//  - DeleteCompleted()
//  - ToggleAll
//==============================================================
abstract class Event {
  Event();
}

class Load extends Event {}

class Add extends Event {
  final Todo todo;
  Add(this.todo);
}

class Update extends Event {
  final Todo todo;
  Update(this.todo);
}

class Delete extends Event {
  final Todo todo;
  Delete(this.todo);
}

class DeleteCompleted extends Event {}

class ToggeAll extends Event {}

//==============================================================
// MAP
//==============================================================

class Init extends Bloc<Event, State> {
  final TodosRepository todosRepository;

  Init({
    @required this.todosRepository,
  }) : super(Loading());

  @override
  Stream<State> mapEventToState(Event event) async* {
    if (event is Load)
      yield* _mapLoad();
    else if (event is Add)
      yield* _mapAdd(event.todo);
    else if (event is Update)
      yield* _mapUpdate(event.todo);
    else if (event is Delete)
      yield* _mapDelete(event.todo);
    else if (event is ToggeAll)
      yield* _mapToggleAll();
    else if (event is DeleteCompleted) {
      yield* _mapDeleteCompleted();
    }
  }

  Stream<State> _mapLoad() async* {
    try {
      List<Todo> todos = todosRepository.loadTodos();
      yield Loaded(todos);
    } catch (_) {
      yield LoadError();
    }
  }

  Stream<State> _mapAdd(Todo todoAdded) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final List<Todo> newList = List.from(initialList)..add(todoAdded);
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<State> _mapUpdate(Todo todoUpdated) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.map((todo) => (todo.id == todoUpdated.id) ? todoUpdated : todo).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<State> _mapDelete(Todo todoDeleted) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.where((todo) => (todo.id != todoDeleted.id)).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  // Nota every checks whether every element of this iterable satisfies test.
  Stream<State> _mapToggleAll() async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final bool allComplete = initialList.every((todo) => todo.complete);
      final newList = initialList.map((todo) => todo.copyWith(complete: !allComplete)).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<State> _mapDeleteCompleted() async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.where((todo) => !todo.complete).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  void _saveToRepository(List<Todo> todos) {}
}
