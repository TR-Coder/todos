import 'package:flutter/material.dart';
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
      // case PantallaMantenimentTasca.nom:
      //   final Tasca tasca = settings.arguments;
      //   return MaterialPageRoute<Tasca>(
      //     builder: (context) => PantallaMantenimentTasca(tasca),
      //   );
      //   break;
      default:
        return null;
    }
  }
}
