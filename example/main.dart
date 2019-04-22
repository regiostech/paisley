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

  /// Render a default page when we hit the index.
  app.get('/', paisleySsr((req, res) {
    return PaisleyApp(
      'ws://localhost:3000/paisley',
      Hello(req),

      // Add some styles, etc. to handle disconnects gracefully
      // by modifying the UI.
      head: '''
      <style>
        body:not(.paisley-disconnected) #disconnected {
          display: none;
        }

        #disconnected {
          color: red;
          font-weight: bold;
        }
      </style>
      ''',
      beforeRoot: '''
      <i id="disconnected">Disconnected. Trying to reconnect...</i>
      ''',
    );
  }));

  /// Serve WebSockets for Paisley.
  app.get('/paisley', paisley((req, res) => Hello(req)));

  // 404 otherwise.
  app.fallback((req, res) => throw AngelHttpException.notFound());

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}

class Hello extends Component {
  final RequestContext req;
  var _clicks = 0;

  Hello(this.req);

  @override
  void afterCreate([PaisleyServer server, Map<String, String> localStorage]) {
    if (server != null) {
      server.eval('console.info("Hello, Paisley!!!")');

      // Restore past click amount, if any.
      if (localStorage.containsKey('clicks'))
        _clicks = int.parse(localStorage['clicks']);

      listen('click', (_) async {
        server.pushHtml('button', 'Clicked ${++_clicks} time(s)!');
        await server.localStorage.setItem('clicks', _clicks);
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
