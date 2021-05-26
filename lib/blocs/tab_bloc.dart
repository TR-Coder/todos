import 'package:flutter_bloc/flutter_bloc.dart';

//==============================================================
// ESTATS:
//==============================================================
enum AppTab { todos, stats }

//==============================================================
// ESDEVENIMENTS:
//  - TabChanged()
//==============================================================
abstract class Event {
  const Event();
}

class TabChanged extends Event {
  final AppTab tab;
  const TabChanged(this.tab);
}

//==============================================================
// MAP
//==============================================================
class Def extends Bloc<Event, AppTab> {
  Def() : super(AppTab.todos);

  @override
  Stream<AppTab> mapEventToState(Event event) async* {
    if (event is TabChanged) {
      yield event.tab;
    }
  }
}
