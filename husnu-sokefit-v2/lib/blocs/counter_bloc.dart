import 'dart:async';

import 'package:crossfit/blocs/bloc.dart';

import 'counter_event.dart';
/// More Detail:
/// https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/
/// https://pub.dev/documentation/rxdart/latest/
/// https://blog.soshace.com/understanding-flutter-bloc-pattern/
class CounterBloc extends BaseBloc {
  int _counter = 0;
  final _counterStateController = StreamController<int>();

  Stream<int> get counterStream => _counterStateController.stream;
  final _counterEventController = StreamController<CounterEvent>();

  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    _counterEventController.stream
        //.where((value) => value == IncrementEvent())//where clause :)
        .listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else
      _counter--;
    _counterStateController.sink.add(_counter);
  }

  @override
  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }

  @override
  void init() {
    // TODO: implement init
  }
  @override
  void refresh() {
    // TODO: implement refresh
  }
}
