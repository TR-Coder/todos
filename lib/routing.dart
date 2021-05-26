import 'package:flutter/material.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/screens/add_edit_screen.dart';
import 'package:todos/screens/detail_screen.dart';
import 'package:todos/screens/home_screen.dart';

class Routing {
  static final Routing _singleton = Routing._();
  factory Routing() => _singleton;
  Routing._();

  get pantallaPrincipal => HomeScreen.nom;

  Route<dynamic> selector(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.nom:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case DetailScreen.nom:
        final String id = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(id: id),
        );
      case AddEditScreen.nom:
        final Map<String, dynamic> args = settings.arguments;
        final bool isEditing = args['isEditing'] as bool;
        final Todo todo = args['todo'] as Todo;
        return MaterialPageRoute(
          builder: (context) => AddEditScreen(
            isEditing: isEditing,
            todo: todo,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
