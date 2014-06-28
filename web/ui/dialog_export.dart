import 'package:polymer/polymer.dart';
import 'dart:html';

import '../game_world.dart';
import '../my_scaffold.dart';

@CustomTag('dialog-export')
class DialogExport extends PolymerElement {
  // attributes
  @published bool opened = false;
  @published String text = "";
  
  DialogExport.created() : super.created();
  
  openedChanged(o, v)
  {
    GameWorld world = querySelector('game-world');
    $["exportedText"].value = "TODO";
  }
}