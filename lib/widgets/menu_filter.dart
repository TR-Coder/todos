import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;
import 'package:todos/models/visivility_filter.dart';

class MenuFilter extends StatelessWidget {
  final bool visible;
  const MenuFilter({this.visible});

  void FilterUpdated(BuildContext context, VisibilityFilter filter) {
    context.read<FILTEREDBLOC.Init>().add(FILTEREDBLOC.Updated(filter));
  }

  @override
  Widget build(BuildContext context) {
    final activeStyle = Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).accentColor);
    return BlocBuilder<FILTEREDBLOC.Init, FILTEREDBLOC.State>(
      builder: (context, state) {},
    );
  }
}
