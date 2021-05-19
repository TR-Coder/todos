import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String note;
  final String task;
  final bool complete;

  Todo({
    String id,
    this.note = '',
    this.task,
    this.complete = false,
  }) : this.id = id ?? Uuid().v4();

  Todo copyWith({String id, String note, String task, bool complete}) {
    return Todo(
      id: id ?? this.id,
      note: note ?? this.note,
      task: task ?? this.task,
      complete: complete ?? this.complete,
    );
  }
}
