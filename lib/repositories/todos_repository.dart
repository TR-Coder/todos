import 'package:todos/models/todo.dart';

class TodosRepository {
  TodosRepository();

  List<Todo> loadTodos() {
    var t1 = Todo(id: '1', note: 'note1', task: 'task1', complete: false);
    var t2 = Todo(id: '2', note: 'note2', task: 'task2', complete: false);
    var t3 = Todo(id: '3', note: 'note3', task: 'task3', complete: false);
    var t4 = Todo(id: '4', note: 'note4', task: 'task4', complete: false);
    var t5 = Todo(id: '5', note: 'note5', task: 'task5', complete: false);
    var t6 = Todo(id: '6', note: 'note6', task: 'task6', complete: false);
    var t7 = Todo(id: '7', note: 'note7', task: 'task7', complete: false);
    var t8 = Todo(id: '8', note: 'note8', task: 'task8', complete: false);
    var t9 = Todo(id: '9', note: 'note9', task: 'task9', complete: false);
    return [t1, t2, t3, t4, t5, t6, t7, t8, t9];
  }
}
