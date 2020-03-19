import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funky_base/funky_base.dart';

void main() {
  const MethodChannel channel = MethodChannel('funky_base');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
