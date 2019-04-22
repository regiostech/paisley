import 'package:angel_serialize/angel_serialize.dart';
part 'rpc.g.dart';

abstract class RpcNames {
  static const String eval = 'eval',
      fire = 'fire',
      html = 'html',
      init = 'init',
      request = 'request';
}

@serializable
abstract class _Eval {
  @notNull
  String get script;
}

@serializable
abstract class _Event {
  @notNull
  String get name;

  dynamic get data;
}

@serializable
abstract class _Init {
  @notNull
  String get rootSelector;

  @DefaultsTo(false)
  bool get isReconnect;

  @DefaultsTo({})
  Map<String, dynamic> localStorage;
}

@serializable
abstract class _HtmlPush {
  @notNull
  String get selector;

  @notNull
  String get html;
}
