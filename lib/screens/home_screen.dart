import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/screens/add_edit_screen.dart';
import 'package:todos/widgets/listView_filtered_todos.dart';
import 'package:todos/widgets/menu_filter.dart';
import 'package:todos/widgets/menu_selection.dart';
import 'package:todos/widgets/show_stats.dart';
import 'package:todos/blocs/tab_bloc.dart' as TABBLOC;
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/widgets/tab_selector.dart';

class HomeScreen extends StatelessWidget {
  static const nom = '/HomeScreen';
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TABBLOC.Def, TABBLOC.AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home Screen'),
            actions: [
              MenuFilter(visible: activeTab == TABBLOC.AppTab.todos), // Menu filters: all, active, completed.
              MenuSelection(), // Menu selection: Mark all complete, clear completed.
            ],
          ),
          body: (activeTab == TABBLOC.AppTab.todos) ? ListViewFilteredTodos() : ShowStats(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => showEditScreen(context),
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            tabSelectedFuncion: (tab) {
              final bloc = context.read<TABBLOC.Def>();
              bloc.add(TABBLOC.TabChanged(tab));
            },
          ),
        );
      },
    );
  }

  void showEditScreen(BuildContext context) async {
    final todo = Todo();
    final result = await Navigator.of(context).pushNamed(AddEditScreen.nom, arguments: {
      'isEditing': false,
      'todo': todo,
    }) as Map;

    if (result != null) {
      final bloc = context.read<TODOSBLOC.Def>();
      bloc.add(
        TODOSBLOC.Add(todo.copyWith(task: result['task'], note: result['note'])),
      );
    }
  }
}
