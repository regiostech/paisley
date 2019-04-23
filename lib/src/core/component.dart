import 'dart:async';
import 'dart:collection';
import 'paisley_server.dart';
import 'rpc.dart';

/// A stateful object that can produce HTML output for a single user.
abstract class Component {
  final Map<String, Component> _children = {};
  final Map<String, Function(dynamic)> _listeners = {};

  /// Invoked after the instance is created by a [PaisleyServer] (or just created in general).
  ///
  /// Useful for initializing resources.
  FutureOr<void> afterCreate(
          [PaisleyServer server, Map<String, String> localStorage]) =>
      null;

  /// Invoked just before the [server] shuts down.
  ///
  /// Useful for closing resources that might otherwise leak.
  FutureOr<void> beforeDestroy([PaisleyServer server]) => null;

  /// Produces HTML output, which is sent verbatim to the browser.
  FutureOr<String> render();

  /// Adds an event listener.
  ///
  /// The function [f] may return a value. If it does, then its return
  /// value will be serialized and sent to the client whenever a `request` RPC is sent.
  void listen(String name, Function(dynamic) f) {
    if (name.contains('.')) {
      throw ArgumentError("Event name cannot contain '.'.");
    } else if (_listeners.containsKey(name)) {
      throw StateError('A listener for "$name" is already defined.');
    } else {
      _listeners[name] = f;
    }
  }

  /// Marks another component as a [child] of this [Component], which allows
  /// it to receive events from this [Component].
  ///
  /// For example, if you registered a child named `foo`, an event named
  /// `foo.bar` in the parent would be sent to the child as `bar`.
  ///
  /// Children can be infinitely nested.
  void registerChild(String name, Component child) {
    if (name.contains('.')) {
      throw ArgumentError("Child name cannot contain '.'.");
    } else if (_listeners.containsKey(name)) {
      throw StateError('A child named "$name" is already defined.');
    } else {
      _children[name] = child;
    }
  }

  /// Dispatches an event down the hierarchy.
  ///
  /// See the documentation for [registerChild] to understand how the event hierarchy works.
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
    } else {
      throw ArgumentError(
          'No event listener named "${sub.last}" exists (from event "${event.name}").');
    }
  }
}
