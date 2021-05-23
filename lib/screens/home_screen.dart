import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/tab_bloc.dart' as TABBLOC;
import 'package:todos/screens/add_edit_screen.dart';
import 'package:todos/widgets/listView_filtered_todos.dart';
import 'package:todos/widgets/show_stats.dart';

class HomeScreen extends StatelessWidget {
  static const nom = '/HomeScreen';
  HomeScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TABBLOC.Init, TABBLOC.AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home Screen'),
            actions: [
              // MenuFilter(), // Menu filters: all, active, completed.
              // MenuSelection(), // Menu selection: Mark all complete, clear completed.
            ],
          ),
          body: (activeTab == TABBLOC.AppTab.todos) ? ListViewFilteredTodos() : ShowStats(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AddEditScreen.nom),
          ),
        );
      },
    );
  }
}
