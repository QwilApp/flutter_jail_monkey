import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterJailMonkey {
  static const MethodChannel _channel = const MethodChannel('flutter_jail_monkey');

  static Future<bool> get isJailBroken => _channel.invokeMethod('isJailBroken');

  static Future<bool> get canMockLocation => _channel.invokeMethod('canMockLocation');

  static Future<bool> get isOnExternalStorage {
    return Platform.isIOS ? new Future.value(false) : _channel.invokeMethod('isOnExternalStorage');
  }
}
