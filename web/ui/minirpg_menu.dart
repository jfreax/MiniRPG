import 'package:polymer/polymer.dart';
import 'dart:html';

import '../game_world.dart';

@CustomTag('minirpg-menu')
class MiniRPGMenu extends PolymerElement {
  // attributes
  @published bool edit = true;
  @published bool debug = true;
  
  MiniRPGMenu.created() : super.created()
  {
    GameWorld world = querySelector('game-world');
    if (world.debug) {
      $['debugCheckbox'].checked = true;
    } else {
      $['debugCheckbox'].checked = false;
    }
    
    if (world.edit) {
      $['editCheckbox'].checked = true;
    } else {
      $['editCheckbox'].checked = false;
    }
  }
  
  debugChanged(CustomEvent event)
  {
    GameWorld world = querySelector('game-world');
    world.setDebug($['debugCheckbox'].checked);
  } 
  
  editChanged(CustomEvent event)
  {
    GameWorld world = querySelector('game-world');
    world.setEdit($['editCheckbox'].checked);
  } 
}