import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/screens/detail_screen.dart';
import 'package:todos/widgets/delete_todo_snackBar.dart';
import 'package:todos/widgets/loading_indicator.dart';
import 'package:todos/widgets/todo_item.dart';
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListViewFilteredTodos extends StatelessWidget {
  ListViewFilteredTodos();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FILTEREDBLOC.Def, FILTEREDBLOC.State>(
      builder: (context, state) {
        if (state is FILTEREDBLOC.Loading) return LoadingIndicator();
        if (state is FILTEREDBLOC.Loaded) {
          final todos = state.filteredTodos;
          return ScrollablePositionedList.builder(
            itemCount: todos.length,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: (direction) => onDismissedItem(context, direction, todo),
                onTap: () => onTapItem(context, todo, index),
                onCheckboxChanged: (_) {
                  final todosBloc = context.read<TODOSBLOC.Def>();
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
  void onTapItem(BuildContext context, Todo todo, int index) async {
    var removeTodo = await Navigator.of(context).pushNamed(DetailScreen.nom, arguments: todo.id);
    if (removeTodo != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        DeleteTodoSnackBar(
          todo: todo,
          onUndo: () {
            context.read<TODOSBLOC.Def>().add(TODOSBLOC.Add(todo));
            itemScrollController.jumpTo(index: index);
          },
        ),
      );
    }
  }

  void onDismissedItem(BuildContext context, DismissDirection direction, Todo todo) {
    final todosBloc = context.read<TODOSBLOC.Def>();
    todosBloc.add(TODOSBLOC.Delete(todo));
    ScaffoldMessenger.of(context).showSnackBar(
      DeleteTodoSnackBar(
        todo: todo,
        onUndo: () => todosBloc.add(TODOSBLOC.Add(todo)),
      ),
    );
  }
}
