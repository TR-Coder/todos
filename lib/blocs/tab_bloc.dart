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
class TabBloc extends Bloc<Event, AppTab> {
  TabBloc() : super(AppTab.todos);

  @override
  Stream<AppTab> mapEventToState(Event event) async* {
    if (event is TabChanged) {
      yield event.tab;
    }
  }
}
