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
      create: (_) => TODOSBLOC.Init(
        todosRepository: TodosRepository(),
      )..add(
          TODOSBLOC.Load(), // CARREGA INICIAL DADES
        ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TABBLOC.Init>(
            create: (context) => TABBLOC.Init(),
          ),
          BlocProvider<FILTEREDBLOC.Init>(
            create: (context) => FILTEREDBLOC.Init(
              todosBloc: context.read<TODOSBLOC.Init>(),
            ),
          ),
          BlocProvider<STATSBLOC.Init>(
            create: (context) => STATSBLOC.Init(
              todosBloc: context.read<TODOSBLOC.Init>(),
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
