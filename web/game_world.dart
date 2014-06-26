import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  // attributes
  @published num width = 0;
  @published num height = 0;
  @published bool debug = false;


  GameWorld.created() : super.created() {
    if (width == 0 || height == 0) {
      width = window.innerWidth;
      height = window.innerHeight;
    }
    
    ($['debugFPS'] as SpanElement).text = "0";
    
    $['renderer'].children.add(new Element.tag('game-node')..attributes["x"] = "100");
    $['renderer'].children.add(new Element.tag('game-node')..attributes["x"] = "10"..attributes["y"] = "60");

  }


}