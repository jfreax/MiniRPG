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
  
  final Random rng = new Random();
  
  // attributes
  @published num size = 5;
  @published num numberOfPlayer = 2;
  @published bool debug = false;
  @published bool edit = false;
  
  // public
  num height;
  num width;
  
  // private
  num _renderTime;
  num _fpsAverage;
  SpanElement _fpsDisplay;
  DivElement _debugDisplay;

  DivElement _renderer;
  svg.SvgElement _background;
  
  Array2d<GameNode> _nodes;
  List<Connection> _connections = new List<Connection>();
  
  GameNode _currentSelectedNode;


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
    
    width = window.innerWidth;
    height = window.innerHeight;
        
    generateMap();
    requestUpdate();
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

  
  void _connectNodes(GameNode node1, GameNode node2)
  {
    svg.PathElement path = new svg.PathElement();
    svg.PathSegList segList = path.pathSegList;
    path.attributes["stroke"] = "red";
    path.attributes["stroke-width"] = "20";
    
    num x1 = node1.x + node1.radius/2;
    num x2 = node2.x + node2.radius/2;
    num y1 = node1.y + node1.radius/2;
    num y2 = node2.y + node2.radius/2;
    
    num max_x = max(x1, x2);
    if (max_x > int.parse(_background.attributes["width"])) {
      _background.attributes["width"] = max_x.toString();
    }
    num max_y = max(y1, y2);
    if (max_y > int.parse(_background.attributes["height"])) {
      _background.attributes["height"] = max_y.toString();
    }

    segList.appendItem(path.createSvgPathSegMovetoAbs(x1, y1));
    segList.appendItem(path.createSvgPathSegLinetoAbs(x2, y2));
    segList.appendItem(path.createSvgPathSegClosePath());
        
    _background.append(path);
    _connections.add(new Connection(node1, node2, path));
  }
  
  void _redrawConnections()
  {
    for( Connection connect in _connections) {
      svg.PathSegList segList = connect.path.pathSegList;
      
      num x1 = connect.node1.x + connect.node1.radius/2;
      num x2 = connect.node2.x + connect.node2.radius/2;
      num y1 = connect.node1.y + connect.node1.radius/2;
      num y2 = connect.node2.y + connect.node2.radius/2;
      
      int max_x = max(x1, x2).round();
      if (max_x > double.parse(_background.attributes["width"]).round()) {
        _background.attributes["width"] = max_x.toString();
      }
      int max_y = max(y1, y2).round();
      if (max_y > double.parse(_background.attributes["height"]).round()) {
         _background.attributes["height"] = max_y.toString();
      }
      
      (segList.elementAt(0) as svg.PathSegMovetoAbs).x = x1;
      (segList.elementAt(0) as svg.PathSegMovetoAbs).y = y1;
      (segList.elementAt(1) as svg.PathSegLinetoAbs).x = x2;
      (segList.elementAt(1) as svg.PathSegLinetoAbs).y = y2;
    }
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
  
  void keyup(KeyboardEvent e, var detail, Node target)
  {
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
    if (e.target is GameNode) {
      _currentSelectedNode = e.target;
    }
  }
  
  void mouseup(Event e)
  {
    _currentSelectedNode = null;
  }
  
  void mousemove(MouseEvent e)
  {
    // move node
    if (edit && _currentSelectedNode != null) {
      Point p = relMouseCoords(e, $["renderer"]);
      _currentSelectedNode.setPosition(p.x - (_currentSelectedNode.clientWidth/2), p.y - (_currentSelectedNode.clientHeight/2));
      _redrawConnections();
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