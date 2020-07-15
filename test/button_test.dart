import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:button/button.dart';

void main() {
  const MethodChannel channel = MethodChannel('button');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Button.platformVersion, '42');
  });
}
