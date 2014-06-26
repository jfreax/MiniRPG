import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  // attributes
  @published bool debug = false;
  
  // private
  num _renderTime;
  num _fpsAverage;
  SpanElement _fpsDisplay;

  DivElement _renderer;


  GameWorld.created() : super.created() {
    _renderer = $['renderer'] as DivElement;
    _fpsDisplay = $['debugFPS'] as SpanElement;
    _fpsDisplay.text = "0";
    
    
    addNode(100, 0);
    addNode(50, 80);
    
    requestUpdate();
  }
  
  void addNode(num x, num y) {
    _renderer.children.add(new Element.tag('game-node')..attributes["x"] = x.toString()..attributes["y"] = y.toString());
  }

  void update(num _) {
    num time = new DateTime.now().millisecondsSinceEpoch;
    if (_renderTime != null) showFps(1000 / (time - _renderTime));
    _renderTime = time;
    
    requestUpdate();
  }
  
  void requestUpdate() {
    window.requestAnimationFrame(update);
  }
  
  void showFps(num fps) {
    if (_fpsAverage == null) _fpsAverage = fps;
    _fpsAverage = fps * 0.05 + _fpsAverage * 0.95;
    _fpsDisplay.text = "${_fpsAverage.round()} fps";
  }

}