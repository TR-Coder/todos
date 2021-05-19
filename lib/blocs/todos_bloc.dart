import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todos_repository.dart';

//==============================================================
// ESTATS:
//  - LoadInProgress()
//  - Loaded(todos)
//  - LoadFailure()
//==============================================================
abstract class TodosState {
  TodosState();
}

class LoadInProgress extends TodosState {}

class Loaded extends TodosState {
  final List<Todo> todos;
  Loaded(this.todos);
}

class LoadFailure extends TodosState {}

//==============================================================
// ESDEVENIMENTS:
//  - Load()
//  - Add(todo)
//  - Update(todo)
//  - Delete(todo)
//  - DeleteCompleted()
//  - ToggleAll
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

class DeleteCompleted extends TodosEvent {}

class ToggeAll extends TodosEvent {}

//==============================================================
// MAP
//==============================================================

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository todosRepository;

  TodosBloc({
    @required this.todosRepository,
  }) : super(LoadInProgress());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
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

  Stream<TodosState> _mapLoad() async* {
    try {
      List<Todo> todos = todosRepository.loadTodos();
      yield Loaded(todos);
    } catch (_) {
      yield LoadFailure();
    }
  }

  Stream<TodosState> _mapAdd(Todo todoAdded) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = List.from(initialList)..add(todoAdded);
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<TodosState> _mapUpdate(Todo todoUpdated) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.map((todo) => (todo.id == todoUpdated.id) ? todoUpdated : todo).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<TodosState> _mapDelete(Todo todoDeleted) async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.where((todo) => (todo.id != todoDeleted.id)).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  // Nota every checks whether every element of this iterable satisfies test.
  Stream<TodosState> _mapToggleAll() async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final bool allComplete = initialList.every((todo) => todo.complete);
      final newList = initialList.map((todo) => todo.copyWith(complete: !allComplete)).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  Stream<TodosState> _mapDeleteCompleted() async* {
    if (state is Loaded) {
      final initialList = (state as Loaded).todos;
      final newList = initialList.where((todo) => !todo.complete).toList();
      yield Loaded(newList);
      _saveToRepository(newList);
    }
  }

  void _saveToRepository(List<Todo> todos) {}
}
