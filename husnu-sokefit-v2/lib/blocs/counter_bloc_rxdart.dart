import 'dart:async';

import 'package:crossfit/blocs/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'counter_event.dart';
/// More Detail:
/// https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/
/// https://pub.dev/documentation/rxdart/latest/
/// https://blog.soshace.com/understanding-flutter-bloc-pattern/
class CounterBlocRxDart extends BaseBloc {
  int _counter = 0;
  final _replaySubject = BehaviorSubject<int>();

  Stream<int> get counterStream => _replaySubject.stream;
  final _counterEventSubject = BehaviorSubject<CounterEvent>();

  Sink<CounterEvent> get counterEventSink => _counterEventSubject.sink;

  CounterBlocRxDart() {
    _counterEventSubject.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else
      _counter--;
    _replaySubject.sink.add(_counter);
  }

  @override
  void dispose() {
    _replaySubject.close();
    _counterEventSubject.close();
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