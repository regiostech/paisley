/// Returns a JavaScript string that connects a WebSocket to a Paisley [endpoint], and
/// renders content into an element with an ID equal to [rootId].
String paisleyJS(String endpoint, String rootId) => '''
document.addEventListener('DOMContentLoaded', function(event) { 
  var ws = new WebSocket('${endpoint}');
  var wsReconn;
  var ids = [];
  var backoff = 100;
  var resolvers = {};

  function getId() {
    var len = ids.length;
    ids.push(null);
    return len;
  }
  

  window.fire = function fire(name, data) {
    ws.send(JSON.stringify({
      jsonrpc: '2.0',
      id: getId(),
      method: 'fire',
      params: {
        name: name,
        data: data
      }
    }));
  };

  window.request = function request(name, data) {
    var id = getId();
    return new Promise(function(resolve) {
      resolvers[id] = resolve;
      ws.send(JSON.stringify({
        jsonrpc: '2.0',
        id: id,
        method: 'request',
        params: {
          name: name,
          data: data
        }
      }));
    });
  };

  function initWs(isReconn) {
      ws.onopen = function() {
          backoff = 100;
          document.body.classList.remove('paisley-disconnected');
          ws.onmessage = function(e) {
          var msg = JSON.parse(e.data);
          var params = msg.params || {};

          if (msg.method === 'html' && ('selector' in params) && ('html' in params)) {
            document.querySelectorAll(params.selector).forEach(function(el) {
              el.innerHTML = params.html;
            });
          } else if (('id' in msg) && msg.method === 'eval' && ('script' in params)) {
            var result = eval(params.script);
            if (result === undefined) result = null;
            ws.send(JSON.stringify({
              jsonrpc: '2.0',
              id: msg.id,
              result: result
            }));
          } else if (('id' in msg) && ('result' in msg)) {
            var resolver = resolvers[msg.id];
            if (resolver) resolve(msg.result);
          }
        };

        ws.send(JSON.stringify({
          jsonrpc: '2.0',
          id: getId(),
          method: 'init',
          params: {
            local_storage: window.localStorage || {},
            root_selector: '#$rootId',
            is_reconnect: isReconn === true
          }
        }));
      };

      ws.onclose = function () {
        document.body.classList.add('paisley-disconnected');
        wsReconn = wsReconn || setTimeout(function() {
          if (ws.readyState !== WebSocket.OPEN) {
            ws = new WebSocket('${endpoint}');
            initWs(true);
            wsReconn = undefined;
          }
        }, backoff + (Math.random() * 1000));
        backoff *= 2;
        if (backoff >= 32000) backoff = 100;
      };
  }

  initWs();
});
''';
