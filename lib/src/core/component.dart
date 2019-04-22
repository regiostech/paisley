import 'dart:async';
import 'dart:collection';
import 'paisley_server.dart';
import 'rpc.dart';

abstract class Component {
  final Map<String, Component> _children = {};
  final Map<String, Function(dynamic)> _listeners = {};

  FutureOr<void> afterCreate(
          [PaisleyServer server, Map<String, dynamic> localStorage]) =>
      null;

  FutureOr<void> beforeDestroy([PaisleyServer server]) => null;

  FutureOr<String> render();

  void listen(String name, Function(dynamic) f) {
    if (name.contains('.')) {
      throw ArgumentError("Event name cannot contain '.'.");
    } else if (_listeners.containsKey(name)) {
      throw StateError('A listener for "$name" is already defined.');
    } else {
      _listeners[name] = f;
    }
  }

  void registerChild(String name, Component child) {
    if (name.contains('.')) {
      throw ArgumentError("Child name cannot contain '.'.");
    } else if (_listeners.containsKey(name)) {
      throw StateError('A child named "$name" is already defined.');
    } else {
      _children[name] = child;
    }
  }

  Future dispatch(Event event) async {
    var sub = Queue<String>.from(event.name.split('.'));
    Component cmp = this;

    while (sub.length > 1) {
      var name = sub.removeFirst();

      if (!cmp._children.containsKey(name)) {
        throw ArgumentError(
            'No child named "$name" exists (from event "${event.name}").');
      } else {
        cmp = cmp._children[name];
      }
    }

    if (cmp._listeners.containsKey(sub.last)) {
      return await cmp._listeners[sub.last](event.data);
    }
  }
}
