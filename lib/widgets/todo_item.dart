import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos/models/todo.dart';

class TodoItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;
  final Todo todo;
  static final keyTodoItemCheckbox = (String id) => Key('TodoItem__${id}__Checkbox');
  static final keyTodoItemTask = (String id) => Key('TodoItem__${id}__Task');
  static final keyTodoItemNote = (String id) => Key('TodoItem__${id}__Note');
  static final keyTodoItem = (String id) => Key('TodoItem__${id}');

  TodoItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onCheckboxChanged,
    @required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: keyTodoItem(todo.id),
      onDismissed: onDismissed,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: keyTodoItemCheckbox(todo.id),
          value: todo.complete,
          onChanged: onCheckboxChanged,
        ),
        title: Hero(
          tag: '${todo.id}__heroTag',
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              todo.task,
              key: keyTodoItemTask(todo.id),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        subtitle: todo.note.isNotEmpty
            ? Text(
                todo.note,
                key: keyTodoItemNote(todo.id),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              )
            : null,
      ),
    );
  }
}
