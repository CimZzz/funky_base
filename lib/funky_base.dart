import 'dart:async';

import 'package:flutter/services.dart';

export 'src/base/page.dart';
export 'src/base/state_mixin.dart';
export 'src/core/page_manager.dart';

class FunkyBasePlugin {
  static const MethodChannel channel =
  const MethodChannel('funky_base');
}
