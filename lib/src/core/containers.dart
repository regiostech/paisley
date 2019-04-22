import 'dart:async';
import 'component.dart';
import 'js.dart';

class PaisleyApp extends Component {
  final String endpoint;
  final Component root;
  final String rootId;
  final String head;
  final String beforeBody;
  final String body;
  final String Function(String) renderContainer;

  PaisleyApp(this.endpoint, this.root,
      {this.rootId = 'app',
      this.head = '',
      this.beforeBody,
      this.body = '',
      this.renderContainer});

  @override
  Future<String> render() async {
    var c = renderContainer ?? (s) => s;
    return '''
    <html>
      <head>$head</head>
      <body>
        ${c('<div id="$rootId">${await root.render()}</div>')}
        $body
        <script>${paisleyJS(endpoint, rootId)}</script>
      </body>
    </html>
    ''';
  }
}
