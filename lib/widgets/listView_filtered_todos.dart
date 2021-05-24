import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/widgets/delete_todo_snackBar.dart';
import 'package:todos/widgets/loading_indicator.dart';
import 'package:todos/widgets/todo_item.dart';
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;

class ListViewFilteredTodos extends StatelessWidget {
  ListViewFilteredTodos();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FILTEREDBLOC.Def, FILTEREDBLOC.State>(
      builder: (context, state) {
        if (state is FILTEREDBLOC.Loading) return LoadingIndicator();
        if (state is FILTEREDBLOC.Loaded) {
          final todos = state.filteredTodos;
          //final bloc = context.read<FILTEREDBLOC.Def>();
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: (direction) => onDismissedItem(context, direction, todo),
                onTap: null,
                onCheckboxChanged: (_) {
                  final todosBloc = context.read<TODOSBLOC.Init>();
                  todosBloc.add(
                    TODOSBLOC.Update(todo.copyWith(complete: !todo.complete)),
                  );
                },
              );
            },
          );
        }
        return Container();
      },
    );
  }

//
  void onTapItem() async {}

  void onDismissedItem(BuildContext context, DismissDirection direction, Todo todo) {
    final todosBloc = context.read<TODOSBLOC.Init>();
    todosBloc.add(TODOSBLOC.Delete(todo));
    ScaffoldMessenger.of(context).showSnackBar(
      DeleteTodoSnackBar(
        todo: todo,
        onUndo: () => todosBloc.add(TODOSBLOC.Add(todo)),
      ),
    );
  }
}
