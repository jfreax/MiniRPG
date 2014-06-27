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
  }
}
