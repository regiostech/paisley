import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:logging/logging.dart';
import 'package:paisley/paisley.dart';
import 'package:paisley/server.dart';

main() async {
  var app = Angel();
  var http = AngelHttp(app);
  app.logger = Logger('paisley')..onRecord.listen(print);

  app.get(
      '/',
      paisleySsr(
          (req, res) => PaisleyApp('ws://localhost:3000/paisley', Hello(req))));

  app.get('/paisley', paisley((req, res) => Hello(req)));

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}

class Hello extends Component {
  final RequestContext req;
  var _clicks = 0;

  Hello(this.req);

  @override
  void afterCreate([PaisleyServer server, Map<String, dynamic> localStorage]) {
    if (server != null) {
      server.eval('console.info("Hello, Paisley!!!")');

      listen('click', (_) async {
        server.pushHtml('button', 'Clicked ${++_clicks} time(s)!');
      });
    }
  }

  @override
  FutureOr<String> render() {
    return '''
    <h1>Session ID: ${req.session.id}</h1>
    <button onclick="fire('click')">Click me!</button>
    ''';
  }
}
