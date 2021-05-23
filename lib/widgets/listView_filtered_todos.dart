import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;
import 'package:todos/widgets/loading_indicator.dart';
import 'package:todos/widgets/todo_item.dart';

class ListViewFilteredTodos extends StatelessWidget {
  ListViewFilteredTodos();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FILTEREDBLOC.Init, FILTEREDBLOC.State>(
      builder: (context, state) {
        if (state is FILTEREDBLOC.Loading) return LoadingIndicator();
        if (state is FILTEREDBLOC.Loaded) {
          final todos = state.filteredTodos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onDismissed: null,
                onTap: null,
                onCheckboxChanged: null,
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
