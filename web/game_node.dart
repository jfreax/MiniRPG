import 'package:polymer/polymer.dart';
//import 'dart:html';

@CustomTag('game-node')
class Node extends PolymerElement {
  // attributes
  @published num x = 0;
  @published num y = 0;
  @published String type = "empty";
  
  Node.created() : super.created();
}
