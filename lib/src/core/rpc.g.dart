// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Eval implements _Eval {
  const Eval({@required this.script});

  @override
  final String script;

  Eval copyWith({String script}) {
    return new Eval(script: script ?? this.script);
  }

  bool operator ==(other) {
    return other is _Eval && other.script == script;
  }

  @override
  int get hashCode {
    return hashObjects([script]);
  }

  @override
  String toString() {
    return "Eval(script=$script)";
  }

  Map<String, dynamic> toJson() {
    return EvalSerializer.toMap(this);
  }
}

@generatedSerializable
class Event implements _Event {
  const Event({@required this.name, this.data});

  @override
  final String name;

  @override
  final dynamic data;

  Event copyWith({String name, dynamic data}) {
    return new Event(name: name ?? this.name, data: data ?? this.data);
  }

  bool operator ==(other) {
    return other is _Event && other.name == name && other.data == data;
  }

  @override
  int get hashCode {
    return hashObjects([name, data]);
  }

  @override
  String toString() {
    return "Event(name=$name, data=$data)";
  }

  Map<String, dynamic> toJson() {
    return EventSerializer.toMap(this);
  }
}

@generatedSerializable
class Init extends _Init {
  Init(
      {Map<String, dynamic> localStorage = const {},
      @required this.rootSelector})
      : this.localStorage = new Map.unmodifiable(localStorage ?? const {});

  @override
  final Map<String, dynamic> localStorage;

  @override
  final String rootSelector;

  Init copyWith({Map<String, dynamic> localStorage, String rootSelector}) {
    return new Init(
        localStorage: localStorage ?? this.localStorage,
        rootSelector: rootSelector ?? this.rootSelector);
  }

  bool operator ==(other) {
    return other is _Init &&
        const MapEquality<String, dynamic>(
                keys: const DefaultEquality<String>(),
                values: const DefaultEquality())
            .equals(other.localStorage, localStorage) &&
        other.rootSelector == rootSelector;
  }

  @override
  int get hashCode {
    return hashObjects([localStorage, rootSelector]);
  }

  @override
  String toString() {
    return "Init(localStorage=$localStorage, rootSelector=$rootSelector)";
  }

  Map<String, dynamic> toJson() {
    return InitSerializer.toMap(this);
  }
}

@generatedSerializable
class HtmlPush implements _HtmlPush {
  const HtmlPush({@required this.selector, @required this.html});

  @override
  final String selector;

  @override
  final String html;

  HtmlPush copyWith({String selector, String html}) {
    return new HtmlPush(
        selector: selector ?? this.selector, html: html ?? this.html);
  }

  bool operator ==(other) {
    return other is _HtmlPush &&
        other.selector == selector &&
        other.html == html;
  }

  @override
  int get hashCode {
    return hashObjects([selector, html]);
  }

  @override
  String toString() {
    return "HtmlPush(selector=$selector, html=$html)";
  }

  Map<String, dynamic> toJson() {
    return HtmlPushSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const EvalSerializer evalSerializer = const EvalSerializer();

class EvalEncoder extends Converter<Eval, Map> {
  const EvalEncoder();

  @override
  Map convert(Eval model) => EvalSerializer.toMap(model);
}

class EvalDecoder extends Converter<Map, Eval> {
  const EvalDecoder();

  @override
  Eval convert(Map map) => EvalSerializer.fromMap(map);
}

class EvalSerializer extends Codec<Eval, Map> {
  const EvalSerializer();

  @override
  get encoder => const EvalEncoder();
  @override
  get decoder => const EvalDecoder();
  static Eval fromMap(Map map) {
    if (map['script'] == null) {
      throw new FormatException("Missing required field 'script' on Eval.");
    }

    return new Eval(script: map['script'] as String);
  }

  static Map<String, dynamic> toMap(_Eval model) {
    if (model == null) {
      return null;
    }
    if (model.script == null) {
      throw new FormatException("Missing required field 'script' on Eval.");
    }

    return {'script': model.script};
  }
}

abstract class EvalFields {
  static const List<String> allFields = <String>[script];

  static const String script = 'script';
}

const EventSerializer eventSerializer = const EventSerializer();

class EventEncoder extends Converter<Event, Map> {
  const EventEncoder();

  @override
  Map convert(Event model) => EventSerializer.toMap(model);
}

class EventDecoder extends Converter<Map, Event> {
  const EventDecoder();

  @override
  Event convert(Map map) => EventSerializer.fromMap(map);
}

class EventSerializer extends Codec<Event, Map> {
  const EventSerializer();

  @override
  get encoder => const EventEncoder();
  @override
  get decoder => const EventDecoder();
  static Event fromMap(Map map) {
    if (map['name'] == null) {
      throw new FormatException("Missing required field 'name' on Event.");
    }

    return new Event(name: map['name'] as String, data: map['data'] as dynamic);
  }

  static Map<String, dynamic> toMap(_Event model) {
    if (model == null) {
      return null;
    }
    if (model.name == null) {
      throw new FormatException("Missing required field 'name' on Event.");
    }

    return {'name': model.name, 'data': model.data};
  }
}

abstract class EventFields {
  static const List<String> allFields = <String>[name, data];

  static const String name = 'name';

  static const String data = 'data';
}

const InitSerializer initSerializer = const InitSerializer();

class InitEncoder extends Converter<Init, Map> {
  const InitEncoder();

  @override
  Map convert(Init model) => InitSerializer.toMap(model);
}

class InitDecoder extends Converter<Map, Init> {
  const InitDecoder();

  @override
  Init convert(Map map) => InitSerializer.fromMap(map);
}

class InitSerializer extends Codec<Init, Map> {
  const InitSerializer();

  @override
  get encoder => const InitEncoder();
  @override
  get decoder => const InitDecoder();
  static Init fromMap(Map map) {
    if (map['root_selector'] == null) {
      throw new FormatException(
          "Missing required field 'root_selector' on Init.");
    }

    return new Init(
        localStorage: map['local_storage'] is Map
            ? (map['local_storage'] as Map).cast<String, dynamic>()
            : const {},
        rootSelector: map['root_selector'] as String);
  }

  static Map<String, dynamic> toMap(_Init model) {
    if (model == null) {
      return null;
    }
    if (model.rootSelector == null) {
      throw new FormatException(
          "Missing required field 'root_selector' on Init.");
    }

    return {
      'local_storage': model.localStorage,
      'root_selector': model.rootSelector
    };
  }
}

abstract class InitFields {
  static const List<String> allFields = <String>[localStorage, rootSelector];

  static const String localStorage = 'local_storage';

  static const String rootSelector = 'root_selector';
}

const HtmlPushSerializer htmlPushSerializer = const HtmlPushSerializer();

class HtmlPushEncoder extends Converter<HtmlPush, Map> {
  const HtmlPushEncoder();

  @override
  Map convert(HtmlPush model) => HtmlPushSerializer.toMap(model);
}

class HtmlPushDecoder extends Converter<Map, HtmlPush> {
  const HtmlPushDecoder();

  @override
  HtmlPush convert(Map map) => HtmlPushSerializer.fromMap(map);
}

class HtmlPushSerializer extends Codec<HtmlPush, Map> {
  const HtmlPushSerializer();

  @override
  get encoder => const HtmlPushEncoder();
  @override
  get decoder => const HtmlPushDecoder();
  static HtmlPush fromMap(Map map) {
    if (map['selector'] == null) {
      throw new FormatException(
          "Missing required field 'selector' on HtmlPush.");
    }

    if (map['html'] == null) {
      throw new FormatException("Missing required field 'html' on HtmlPush.");
    }

    return new HtmlPush(
        selector: map['selector'] as String, html: map['html'] as String);
  }

  static Map<String, dynamic> toMap(_HtmlPush model) {
    if (model == null) {
      return null;
    }
    if (model.selector == null) {
      throw new FormatException(
          "Missing required field 'selector' on HtmlPush.");
    }

    if (model.html == null) {
      throw new FormatException("Missing required field 'html' on HtmlPush.");
    }

    return {'selector': model.selector, 'html': model.html};
  }
}

abstract class HtmlPushFields {
  static const List<String> allFields = <String>[selector, html];

  static const String selector = 'selector';

  static const String html = 'html';
}
