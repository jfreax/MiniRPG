import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:svg' as svg;
import 'dart:math';

import 'game_node.dart';

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  final int MIN_WIDTH = 800;
  final int MIN_HEIGHT= 600;
  
  final Random rng = new Random();
  
  // attributes
  @published num size = 5;
  @published num numberOfPlayer = 2;
  @published bool debug = false;
  
  // private
  num _renderTime;
  num _fpsAverage;
  SpanElement _fpsDisplay;
  DivElement _debugDisplay;

  DivElement _renderer;
  svg.SvgElement _background;


  GameWorld.created() : super.created()
  {
    _renderer = $['renderer'] as DivElement;
    _background = $['background'] as svg.SvgElement;
    
    _fpsDisplay = $['debugFPS'] as SpanElement;
    _fpsDisplay.text = "0";
    
    _debugDisplay = $['debug'] as DivElement;
        
    generateMap();
    requestUpdate();
  }
  
  void generateMap()
  {
    GameNode node1 = _addNode(100, 0);
    GameNode node2 = _addNode(100, 80);
    
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

    segList.appendItem(path.createSvgPathSegMovetoAbs(node1.x + node1.radius/2, node1.y + node1.radius/2));
    segList.appendItem(path.createSvgPathSegLinetoAbs(node2.x + node2.radius/2, node2.y + node2.radius/2));
    segList.appendItem(path.createSvgPathSegClosePath());
    
    _background.append(path);
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
    if (debug) {
      _debugDisplay.style.visibility = "visible";
    } else {
      _debugDisplay.style.visibility = "hidden";
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
  
  // input events
  keyup(KeyboardEvent e, var detail, Node target)
  {
    print("OK");
    print("Key $e.keyCode");
  }

}