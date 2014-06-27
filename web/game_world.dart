import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:svg' as svg;
import 'dart:math';
import 'dart:convert';

import 'utils/Array2d.dart';
import 'game_node.dart';

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  final String APP_NAME = "MiniRPG";
  final int MIN_WIDTH = 800;
  final int MIN_HEIGHT= 600;
  final int CONNECTION_LINE_WIDTH = 20;
  
  final Random rng = new Random();
  
  // attributes
  @published num size = 5;
  @published num numberOfPlayer = 2;
  @published bool debug = false;
  @published bool edit = false;
  
  // public
  num height = 800;
  num width = 600;
  
  // private
  num _renderTime;
  num _fpsAverage;
  SpanElement _fpsDisplay;
  DivElement _debugDisplay;

  DivElement _renderer;
  svg.SvgElement _background;
  
  Array2d<GameNode> _nodes;
  List<Connection> _connections = new List<Connection>();
  
  var _currentHovered = null;
  GameNode _currentSelectedNode = null;
  bool _ctrlKey = false;
  Connection _newConnection = null;


  GameWorld.created() : super.created()
  {
    _nodes = new Array2d<GameNode>(4 * size + 10, size + 10);
    
    _renderer = $['renderer'] as DivElement;
    _background = $['background'] as svg.SvgElement;
    
    _fpsDisplay = $['debugFPS'] as SpanElement;
    _fpsDisplay.text = "0";
    
    _debugDisplay = $['debug'] as DivElement;
    if (window.localStorage.containsKey("debug")) {
      setDebug(window.localStorage["debug"].toLowerCase() == "true");
    }
    
    if (window.localStorage.containsKey("edit")) {
      setEdit(window.localStorage["edit"].toLowerCase() == "true");
    }
    
    width = max(this.width, MIN_WIDTH);
    height = max(this.height, MIN_HEIGHT);
        
    generateMap();
    requestUpdate();
    
    window..onKeyDown.listen(keydown)
          ..onKeyUp.listen(keyup);
  }
  
  final String example_world = """{ 
        "size": {"x": "800", "y": "600"},
        "nodes": []
      } """;
  
  void generateMap()
  {
    Map world = JSON.decode(example_world);
    print(world["size"]["x"]);
    
    //for(int i = 0; i < 20; i++) {
    //  int pos = 0;
    //  int lvl = ((rng.nextInt(size) + rng.nextInt(size)) / 2).round();;

    //  for(int j = 0; j < lvl; j++) {
    //    pos += rng.nextInt(size*4);
    //  }
    //  pos = (pos/lvl).round();
      
    //  if (_nodes[pos][lvl] == null) {
    //    GameNode newNode = _addNode(pos, lvl);
    //  }
    //}
    GameNode node1 = _addNode(30, 0);
    GameNode node2 = _addNode(90, 100);
    //GameNode node3 = _addNode(2, 1);
    //_addNode(3, 1);_addNode(4, 1);
    
    _connectNodes(node1, node2);
  }
  
  GameNode _addNode(num x, num y)
  {
    GameNode newNode = new Element.tag('game-node') as GameNode;
    newNode.setPosition(x, y);
    _renderer.children.add(newNode);
    
    return newNode;
  }
  
  void _removeNode(GameNode node)
  {
    var toRemove = _connections.where((Connection c) => c.node1 == node || c.node2 == node);
    toRemove.forEach((Connection c) => c.path.remove());
    _connections.removeWhere((Connection c) => c.node1 == node || c.node2 == node);
    
    node.remove();
  }

  
  Connection _connectNodes(GameNode node1, GameNode node2)
  {
    svg.PathElement path = new svg.PathElement();
    svg.PathSegList segList = path.pathSegList;
    path.attributes["stroke"] = "red";
    path.attributes["stroke-width"] = CONNECTION_LINE_WIDTH.toString();
    
    segList.appendItem(path.createSvgPathSegMovetoAbs(0, 0));
    segList.appendItem(path.createSvgPathSegLinetoAbs(0, 0));
    segList.appendItem(path.createSvgPathSegClosePath());
        
    Connection newConnection = new Connection(node1, node2, path);
    _redrawConnection(newConnection);
    
    _connections.add(newConnection);
    _background.append(path);
        
    return newConnection;
  }
  
  void _removeConnection(Connection connection)
  {
    connection.path.remove();
    _connections.remove(connection);
  }
  
  void _removeConnectionFromPath(svg.PathElement path)
  {
    Connection c = _connections.firstWhere((Connection c) => c.path == path);
    if (c != null) {
      _removeConnection(c);
    }
  }
  
  void _redrawConnections()
  {
    for( Connection connect in _connections) {
      _redrawConnection(connect);
    }
  }
  
  void _redrawConnection(Connection connect)
  {
    svg.PathSegList segList = connect.path.pathSegList;
    
    num x1 = connect.node1.x + connect.node1.radius/2;
    num x2 = connect.node2.x + connect.node2.radius/2;
    num y1 = connect.node1.y + connect.node1.radius/2;
    num y2 = connect.node2.y + connect.node2.radius/2;
    
    int max_x = max(x1, x2).ceil() + CONNECTION_LINE_WIDTH;
    if (max_x > double.parse(_background.attributes["width"]).floor()) {
      _background.attributes["width"] = max_x.toString();
    }
    int max_y = max(y1, y2).ceil() + CONNECTION_LINE_WIDTH;
    if (max_y > double.parse(_background.attributes["height"]).floor()) {
       _background.attributes["height"] = max_y.toString();
    }
    
    (segList.elementAt(0) as svg.PathSegMovetoAbs).x = x1;
    (segList.elementAt(0) as svg.PathSegMovetoAbs).y = y1;
    (segList.elementAt(1) as svg.PathSegLinetoAbs).x = x2;
    (segList.elementAt(1) as svg.PathSegLinetoAbs).y = y2;
  }

  void _update(num _)
  {
    if (debug) {
      num time = new DateTime.now().millisecondsSinceEpoch;
      if (_renderTime != null) showFps(1000 / (time - _renderTime));
      _renderTime = time;
    }
    
    requestUpdate();
  }
  
  // public
  
  void setDebug(bool debug)
  {
    this.debug = debug;
    window.localStorage["debug"] = debug.toString();
    
    if (debug) {
      _debugDisplay.style.visibility = "visible";
    } else {
      _debugDisplay.style.visibility = "hidden";
    }
  }
  
  void setEdit(bool edit)
  {
    this.edit = edit;
    window.localStorage["edit"] = edit.toString();
    
    if (edit) {
      querySelector("my-scaffold").attributes["headline"] = "$APP_NAME - Edit Mode";
    } else {
      querySelector("my-scaffold").attributes["headline"] = APP_NAME;
    }
  }
  
  void requestUpdate()
  {
    window.requestAnimationFrame(_update);
  }

  void showFps(num fps) {
    if (_fpsAverage == null) _fpsAverage = fps;
    _fpsAverage = fps * 0.05 + _fpsAverage * 0.95;
    _fpsDisplay.text = "${_fpsAverage.round()} fps";
  }
  
  /**
   *  Input events
   */
  
  void keydown(KeyboardEvent e)
  {
    _ctrlKey = e.ctrlKey;
  }
  
  void keyup(KeyboardEvent e)
  {
    _ctrlKey = e.ctrlKey;
    
    print(e.keyCode);
    switch (e.keyCode) {
      case 46: // del
        if (_currentHovered is GameNode) {
          _removeNode(_currentHovered);
        } else if (_currentHovered is svg.PathElement) {
          _removeConnectionFromPath(_currentHovered);
        }
        break;
      default:
        break;
    }
  }
  
  void mousedbclick(MouseEvent e)
  {
    if (!(e.target is GameNode)) {
      Point p = relMouseCoords(e, $["renderer"]);
      _addNode(p.x, p.y);
    }
  }
  
  void mousedown(Event e)
  {
    if (_newConnection != null) {
      if (e.target is GameNode && e.currentTarget != _newConnection.node1) {
        _connectNodes(_newConnection.node1, e.target);
      }
      
      _removeConnection(_newConnection);
      _newConnection = null;
    }
    
    if (e.target is GameNode) {
      _currentSelectedNode = e.target;
      if (_ctrlKey) {
        _newConnection = 
            _connectNodes(_currentSelectedNode, (new Element.tag('game-node') as GameNode)
                ..setPosition(_currentSelectedNode.x, _currentSelectedNode.y)..grid = false);
      }
    }
  }
  
  void mouseup(Event e)
  {
    _currentSelectedNode = null;
  }
  
  void mousemove(MouseEvent e)
  {
    _currentHovered = e.target;
    if (edit) {
      Point p = relMouseCoords(e, $["renderer"]);

      if (_newConnection != null) { // add new connection 
        _newConnection.node2.setPosition(p.x - (_newConnection.node2.clientWidth/2), p.y - (_newConnection.node2.clientHeight/2));
        _redrawConnection(_newConnection);
      } else { // move node
        if (_currentSelectedNode != null) {
          _currentSelectedNode.setPosition(p.x - (_currentSelectedNode.clientWidth/2), p.y - (_currentSelectedNode.clientHeight/2));
          _redrawConnections();
        }
      }
    }
  }
  
  /**
   * Helper functions
   */

  Point relMouseCoords(MouseEvent event, HtmlElement currentElement) {
      num totalOffsetX = 0;
      num totalOffsetY = 0;
      num x = 0;
      num y = 0;

      do {
          totalOffsetX += currentElement.offsetLeft - currentElement.scrollLeft;
          totalOffsetY += currentElement.offsetTop - currentElement.scrollTop;
          
          currentElement = currentElement.offsetParent;
      }
      while(currentElement != null);

      x = event.page.x - totalOffsetX;
      y = event.page.y - totalOffsetY;

      return new Point(x, y);
  }
}

class Connection
{
  GameNode node1;
  GameNode node2;
  svg.PathElement path;
  
  Connection(GameNode node1, GameNode node2, svg.PathElement path)
  {
    this.node1 = node1;
    this.node2 = node2;
    this.path = path;
  }
}