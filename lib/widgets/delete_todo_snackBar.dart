import 'package:flutter/material.dart';
import 'package:todos/models/todo.dart';

class DeleteTodoSnackBar extends SnackBar {
  DeleteTodoSnackBar({
    @required Todo todo,
    @required VoidCallback onUndo,
  }) : super(
          content: Text(
            'Delete',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: onUndo,
          ),
        );
}
