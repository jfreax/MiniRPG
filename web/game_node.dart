library mini_rpg.gamenode;

import 'package:polymer/polymer.dart';
import 'dart:html';

import 'game_world.dart';

@CustomTag('game-node')
class GameNode extends PolymerElement {
  final int NODE_DISTANCE = 4;
  
  // attributes
  @published num x = 0;
  @published num y = 0;
  @published int radius = 56;
  @published String type = "empty";
  
  GameNode.created() : super.created();
  
  
  void setPosition(num x, num y)
  {
    GameWorld world = querySelector("game-world");
    
    x -= x % (radius + NODE_DISTANCE);
    y -= y % (radius + NODE_DISTANCE);
    
    if (x < 0) {
      x = 0;
    } else if (x + radius > world.width) {
      x -= (radius + NODE_DISTANCE);
    }
    if (y < 0) {
      y = 0;
    } else if(y + radius > world.height) {
      y -= (radius + NODE_DISTANCE);
    }
    
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
