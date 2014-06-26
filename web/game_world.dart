import 'package:polymer/polymer.dart';
import 'package:pixi/pixi.dart';
import 'dart:html' hide Rectangle;

@CustomTag('game-world')
class GameWorld extends PolymerElement {
  // attributes
  @published num width = 0;
  @published num height = 0;


  GameWorld.created() : super.created() {
//    if (width == 0 || height == 0) {
//      width = window.innerWidth;
//      height = window.innerHeight - $["debug"].offsetHeight;
//    }
//
//    Stage stage = new Stage(0xEEEEEE);
//    Renderer renderer = autoDetectRenderer(width, height, $["renderer"]);
//
//    renderer.render(stage);
  }


}