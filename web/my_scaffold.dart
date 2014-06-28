library minirpg.my_scaffold;

import 'dart:html';
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;
import 'package:core_elements/src/common.dart' show DomProxyMixin;
 
class MyScaffold extends HtmlElement with DomProxyMixin {
  MyScaffold.created() : super.created();
  
  String get headline => jsElement['headline'];
  set headline(String value) { jsElement['headline'] = value; }
  
  String get download => jsElement['download'];
  set download(String value) { jsElement['download'] = value; }
  
  String get exportText => jsElement['exportText'];
  set exportText(String value) { jsElement['exportText'] = value; }
  
  bool get downloadDialog => jsElement['downloadDialog'];
  set downloadDialog(bool value) { jsElement['downloadDialog'] = value;  }

  /// When the browser window size is smaller than the `responsiveWidth`,
  /// `core-drawer-panel` changes to a narrow layout. In narrow layout,
  /// the drawer will be stacked on top of the main panel.
  String get responsiveWidth => jsElement['responsiveWidth'];
  set responsiveWidth(String value) { jsElement['responsiveWidth'] = value; }

  /// Used to control the header and scrolling behaviour of `core-header-panel`
  String get mode => jsElement['mode'];
  set mode(String value) { jsElement['mode'] = value; }

  /// Toggle the drawer panel
  void togglePanel() {
      jsElement.callMethod('togglePanel', []);
  }

  /// Open the drawer panel
  void openDrawer() =>
      jsElement.callMethod('openDrawer', []);

  /// Close the drawer panel
  void closeDrawer() =>
      jsElement.callMethod('closeDrawer', []);
}
@initMethod
upgradeMyScaffold() => registerDartType('my-scaffold', MyScaffold);
 