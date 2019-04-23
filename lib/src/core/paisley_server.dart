import 'dart:convert';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc_2;
import 'component.dart';
import 'rpc.dart';

class PaisleyServer {
  final json_rpc_2.Peer peer;
  final String rootSelector;
  final Component root;
  var _init = false;
  PaisleyLocalStorage _localStorage;

  PaisleyServer(this.peer, this.rootSelector, this.root) {
    _localStorage = PaisleyLocalStorage(this);
    _listen();
    peer.listen();
  }

  Future get done => peer.done;

  PaisleyLocalStorage get localStorage => _localStorage;

  void _listen() {
    peer.registerMethod(RpcNames.fire, (json_rpc_2.Parameters params) async {
      var event = eventSerializer.decode(params.asMap);
      await root.dispatch(event);
    });

    peer.registerMethod(RpcNames.request, (json_rpc_2.Parameters params) async {
      var event = eventSerializer.decode(params.asMap);
      return await root.dispatch(event);
    });

    peer.registerMethod(RpcNames.init, (json_rpc_2.Parameters params) async {
      if (!_init) {
        var init = initSerializer.decode(params.asMap);
        await root.afterCreate(
            this, init.localStorage?.cast<String, String>() ?? {});
        var contents = await root.render();
        if (init.isReconnect != true) pushHtml(init.rootSelector, contents);
        _init = true;
      }
    });
  }

  Future<Object> eval(String script) {
    var msg = Eval(script: script);
    return peer.sendRequest('eval', msg.toJson());
  }

  Future<void> patch(String selector, Component component) async {
    pushHtml(selector, await component.render());
  }

  Future<void> refresh() async {
    await patch(rootSelector, root);
  }

  void pushHtml(String selector, String html) {
    var push = HtmlPush(selector: selector, html: html);
    peer.sendNotification(RpcNames.html, push.toJson());
  }
}

class PaisleyLocalStorage {
  final PaisleyServer _server;

  PaisleyLocalStorage(this._server);

  Future<void> clear() {
    return _server.eval('localStorage.clear()');
  }

  Future<bool> containsKey(String key) {
    return getItem(key).then((v) => v != null);
  }

  Future<Object> getItem(String key) {
    var encoded = json.encode(key);
    return _server.eval('localStorage.getItem($encoded)');
  }

  Future<void> removeItem(String key) {
    var encoded = json.encode(key);
    return _server.eval('localStorage.removeItem($encoded)');
  }

  Future<void> setItem(String key, value) {
    var encodedKey = json.encode(key);
    var encodedValue = json.encode(value);
    return _server.eval(
        'localStorage.setItem($encodedKey, JSON.stringify($encodedValue))');
  }
}
