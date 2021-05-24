import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/models/visivility_filter.dart';
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;

class MenuFilter extends StatelessWidget {
  final bool visible;
  MenuFilter({this.visible});

  List<Widget> menuItems(BuildContext context, VisibilityFilter activeFilter) {
    final items = <PopupMenuItem<VisibilityFilter>>[];
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).accentColor);

    final itemAll = PopupMenuItem<VisibilityFilter>(
      value: VisibilityFilter.all,
      child: Text('Show all', style: (activeFilter == VisibilityFilter.all) ? activeStyle : defaultStyle),
    );

    final itemActive = PopupMenuItem<VisibilityFilter>(
      value: VisibilityFilter.active,
      child: Text('Show active', style: (activeFilter == VisibilityFilter.active) ? activeStyle : defaultStyle),
    );

    final itemCompleted = PopupMenuItem<VisibilityFilter>(
      value: VisibilityFilter.completed,
      child: Text('Show complete', style: (activeFilter == VisibilityFilter.completed) ? activeStyle : defaultStyle),
    );

    items.addAll([itemAll, itemActive, itemCompleted]);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FILTEREDBLOC.Def, FILTEREDBLOC.State>(
      builder: (context, state) {
        final activeFilter = (state is FILTEREDBLOC.Loaded) ? state.activeFilter : VisibilityFilter.all;
        final bloc = context.read<FILTEREDBLOC.Def>();

        final button = PopupMenuButton<VisibilityFilter>(
          onSelected: (VisibilityFilter selection) => bloc.add(FILTEREDBLOC.Updated(selection)),
          itemBuilder: (context) => menuItems(context, activeFilter),
          icon: Icon(Icons.filter_list),
        );

        return AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: Duration(milliseconds: 150),
          child: visible ? button : IgnorePointer(child: button),
        );
      },
    );
  }
}
