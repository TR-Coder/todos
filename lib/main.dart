import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/simple_bloc_observer.dart';
import 'package:todos/repositories/todos_repository.dart';
import 'package:todos/routing.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;
import 'package:todos/blocs/tab_bloc.dart' as TABBLOC;
import 'package:todos/blocs/filtered_bloc.dart' as FILTEREDBLOC;
import 'package:todos/blocs/stats_bloc.dart' as STATSBLOC;

void main() {
  /* == INICIALITZAR ELS BLOCS == */
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (_) => TODOSBLOC.Def(
        todosRepository: TodosRepository(),
      )..add(
          TODOSBLOC.Load(), // CARREGA INICIAL DADES
        ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TABBLOC.Def>(
            create: (context) => TABBLOC.Def(),
          ),
          BlocProvider<FILTEREDBLOC.Def>(
            create: (context) => FILTEREDBLOC.Def(
              todosBloc: context.read<TODOSBLOC.Def>(),
            ),
          ),
          BlocProvider<STATSBLOC.Def>(
            create: (context) => STATSBLOC.Def(
              todosBloc: context.read<TODOSBLOC.Def>(),
            ),
          ),
        ],
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: ThemeData(primarySwatch: Colors.purple),
      onGenerateRoute: Routing().selector,
      initialRoute: Routing().pantallaPrincipal,
    );
  }
}
