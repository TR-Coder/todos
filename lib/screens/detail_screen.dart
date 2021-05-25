import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/blocs/todos_bloc.dart' as TODOSBLOC;

class DetailScreen extends StatelessWidget {
  static const nom = '/DetailScreen';
  final String id;
  DetailScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TODOSBLOC.Init, TODOSBLOC.State>(
      builder: (context, state) {
        final todo = (state as TODOSBLOC.Loaded).todos.firstWhere(
              (todo) => todo.id == id,
              orElse: () => null,
            );
        return Scaffold(
          appBar: AppBar(
            title: Text('Todo details'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  final bloc = context.read<TODOSBLOC.Init>();
                  bloc.add(TODOSBLOC.Delete(todo));
                  Navigator.pop(context, todo);
                },
              )
            ],
          ),
          body: (todo == null)
              ? Container
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Checkbox(
                          value: todo.complete,
                          onChanged: (_) {
                            final bloc = context.read<TODOSBLOC.Init>();
                            final updateTodo = todo.copyWith(complete: !todo.complete);
                            bloc.add(TODOSBLOC.Update(updateTodo));
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: '${todo.id}__heroTag',
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 8, bottom: 16),
                                child: Text(
                                  todo.task,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                            Text(todo.note),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              if (todo != null) {} /* pantalla todoUpdate */
            },
          ),
        );
      },
    );
  }
}
