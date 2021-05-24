import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;

class DetailScreen extends StatelessWidget {
  final String id;
  DetailScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TODOSBLOC.Init, TODOSBLOC.State>(
      builder: (context, state) {},
    );
  }
}
