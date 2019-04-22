import 'dart:async';
import 'component.dart';
import 'js.dart';

/// Creates an HTML page that connects a WebSocket to Paisley and handles
/// reconnections, etc.
class PaisleyApp extends Component {
  /// The WebSocket endpoint to connect to.
  final String endpoint;

  /// The root component to draw.
  final Component root;

  /// The ID of the root element on the page.
  ///
  /// Defaults to `'app'`.
  final String rootId;

  /// Additional HTML to include in the `<head>`.
  final String head;

  /// Additional HTML to include before rendering the [root].
  final String beforeRoot;

  /// Additional HTML to include after rendering the [root].
  final String body;

  /// An optional function that can be used if the [root] should be wrapped in another element.
  ///
  /// By default, this just returns whatever it is given, which is a `<div id="app">`
  /// (replace `app` with whatever [rootId] is).
  final String Function(String) renderContainer;

  PaisleyApp(this.endpoint, this.root,
      {this.rootId = 'app',
      this.head = '',
      this.beforeRoot = '',
      this.body = '',
      this.renderContainer});

  @override
  Future<String> render() async {
    var c = renderContainer ?? (s) => s;
    return '''
    <html>
      <head>$head</head>
      <body>
        $beforeRoot
        ${c('<div id="$rootId">${await root.render()}</div>')}
        <script>${paisleyJS(endpoint, rootId)}</script>
        $body
      </body>
    </html>
    ''';
  }
}
