// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:wiredash/src/common/renderer/renderer.dart';

Renderer getRenderer() {
  return isCanvasKitRenderer ? Renderer.canvasKit : Renderer.html;
}

bool get isCanvasKitRenderer {
  final flutterCanvasKit = js.context['flutterCanvasKit'];
  return flutterCanvasKit != null;
}
