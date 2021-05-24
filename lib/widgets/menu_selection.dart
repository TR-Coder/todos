import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;

enum ExtraAction { toggleAllComplete, clearCompleted }

class MenuSelection extends StatelessWidget {
  const MenuSelection();

  List<Widget> menuItems(BuildContext context, bool allComplete) {
    final items = <PopupMenuItem<ExtraAction>>[];

    final itemToggle = PopupMenuItem<ExtraAction>(
      value: ExtraAction.toggleAllComplete,
      child: Text(allComplete ? 'Mark all incomplete' : 'Mark all complete'),
    );

    final itemClearCompleted = PopupMenuItem<ExtraAction>(
      value: ExtraAction.clearCompleted,
      child: Text('Clear completed'),
    );

    items.addAll([itemToggle, itemClearCompleted]);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TODOSBLOC.Init, TODOSBLOC.State>(
      builder: (context, state) {
        if (state is TODOSBLOC.Loaded) {
          final bloc = context.read<TODOSBLOC.Init>();
          final blocState = (bloc.state as TODOSBLOC.Loaded);
          final allComplete = blocState.todos.every((todo) => todo.complete);
          return PopupMenuButton<ExtraAction>(
            onSelected: (action) {
              switch (action) {
                case ExtraAction.clearCompleted:
                  bloc.add(TODOSBLOC.DeleteCompleted());
                  break;
                case ExtraAction.toggleAllComplete:
                  bloc.add(TODOSBLOC.ToggeAll());
                  break;
              }
            },
            itemBuilder: (context) => menuItems(context, allComplete),
          );
        }
        return Container();
      },
    );
  }
}
