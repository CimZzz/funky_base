import 'dart:async';

import 'package:flutter/services.dart';

export 'src/base/page.dart';
export 'src/base/state_mixin.dart';
export 'src/core/page_manager.dart';

class FunkyBase {
  static const MethodChannel _channel =
  const MethodChannel('funky_base');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String> test(dynamic any) async {
    final String version = await _channel.invokeMethod('test2', any);
    return version;
  }
}
