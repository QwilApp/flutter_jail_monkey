import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterJailMonkey {
  static const MethodChannel _channel = const MethodChannel('flutter_jail_monkey');

  static Future<bool> get isJailBroken async => await _channel.invokeMethod('isJailBroken');

  static Future<bool> get canMockLocation async => await _channel.invokeMethod('canMockLocation');

  static Future<bool> get isOnExternalStorage async {
    return Platform.isIOS ? false : await _channel.invokeMethod('isOnExternalStorage');
  }
}
