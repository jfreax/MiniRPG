library mini_rpg.gamenode;

import 'package:polymer/polymer.dart';
//import 'dart:html';

@CustomTag('game-node')
class GameNode extends PolymerElement {
  // attributes
  @published num x = 0;
  @published num y = 0;
  @published int radius = 56;
  @published String type = "empty";
  
  GameNode.created() : super.created();
  
  
  void setPosition(num x, num y)
  {
    attributes["x"] = x.toString();
    attributes["y"] = y.toString();
    
    // WORKAROUND
    // ShadowDOM Polyfill does not support bindings in style elements
    // https://github.com/Polymer/polymer/issues/456
    style.left = "${x}px";
    style.top = "${y}px";
    this.shadowRoot.querySelector('.fab').style
      ..width = "${radius}px"
      ..height = "${radius}px";
  }
}
