import 'package:flutter/material.dart';
import 'package:todos/blocs/tab_bloc.dart' as TABBLOC;

class TabSelector extends StatelessWidget {
  final TABBLOC.AppTab activeTab;
  final Function(TABBLOC.AppTab) tabSelectedFuncion;
  static const tabs = Key('__tabs__');
  static const todoTab = Key('__todoTab__');
  static const statsTab = Key('__statsTab__');
  TabSelector({
    @required this.activeTab,
    @required this.tabSelectedFuncion,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: TABBLOC.AppTab.values.indexOf(activeTab),
      onTap: (index) => tabSelectedFuncion(TABBLOC.AppTab.values[index]),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Stats'),
      ],
    );
  }
}
