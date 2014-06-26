import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  // attributes
  @published num width = 0;
  @published num height = 0;
  @published bool debug = false;
  
  DivElement _renderer;
  SpanElement _fpsCounter;


  GameWorld.created() : super.created() {
    if (width == 0 || height == 0) {
      width = window.innerWidth;
      height = window.innerHeight;
    }
    
    _renderer = $['renderer'] as DivElement;
    _fpsCounter = $['debugFPS'] as SpanElement;
    _fpsCounter.text = "0";
    
    
    addNode(100, 0);
    addNode(50, 80);
  }
  
  addNode(num x, num y) {
    _renderer.children.add(new Element.tag('game-node')..attributes["x"] = x.toString()..attributes["y"] = y.toString());
  }


}