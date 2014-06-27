import 'package:polymer/polymer.dart';
import 'dart:html';
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

  DivElement _renderer;


  GameWorld.created() : super.created()
  {
    _renderer = $['renderer'] as DivElement;
    _fpsDisplay = $['debugFPS'] as SpanElement;
    _fpsDisplay.text = "0";
    
    generateMap();
    requestUpdate();
  }
  
  void generateMap()
  {
    _addNode(100, 0);
    _addNode(100, 80);
    
  }
  
  void _addNode(num x, num y)
  {
    GameNode newNode = new Element.tag('game-node') as GameNode;
    newNode.setPosition(x, y);

    
    _renderer.children.add(newNode);
  }

  void _update(num _)
  {
    num time = new DateTime.now().millisecondsSinceEpoch;
    if (_renderTime != null) showFps(1000 / (time - _renderTime));
    _renderTime = time;
    
    requestUpdate();
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