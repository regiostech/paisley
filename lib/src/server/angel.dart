import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc_2;
import 'package:http_parser/http_parser.dart';
import 'package:paisley/paisley.dart';
import 'package:web_socket_channel/io.dart';

RequestHandler paisley(
    FutureOr<Component> Function(RequestContext, ResponseContext) root,
    {String rootSelector: '#app'}) {
  return (req, res) async {
    if (req is HttpRequestContext &&
        WebSocketTransformer.isUpgradeRequest(req.rawRequest)) {
      await res.detach();
      var websocket = await WebSocketTransformer.upgrade(req.rawRequest);
      var channel = IOWebSocketChannel(websocket);
      var peer = json_rpc_2.Peer(channel.cast<String>());
      var cmp = await root(req, res);
      var paisley = PaisleyServer(peer, rootSelector, cmp);
      await paisley.done;
      await cmp.beforeDestroy();
    } else {
      throw AngelHttpException.badRequest(
          message: 'This endpoint only supports WebSockets.');
    }
  };
}

RequestHandler paisleySsr(
    FutureOr<Component> Function(RequestContext, ResponseContext) root) {
  return (req, res) async {
    var cmp = await root(req, res);
    await cmp.afterCreate();
    var contents = await cmp.render();
    await cmp.beforeDestroy();
    res
      ..contentType = MediaType('text', 'html', {'charset': 'utf8'})
      ..write(contents);
  };
}
