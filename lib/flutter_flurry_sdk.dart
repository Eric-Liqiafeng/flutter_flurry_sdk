import 'dart:async';

import 'package:flutter/services.dart';

class FlutterFlurrySdk {
  static const MethodChannel channel =
      const MethodChannel('flutter_flurry_sdk/message');

  static Future<void> initialize({
    String androidKey = "",
    String iosKey = "",
    bool enableLog = true,
    bool performanceMetrics = true,
    String appVersion,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args["api_key_android"] = androidKey;
    args["api_key_ios"] = iosKey;
    args["is_log_enabled"] = enableLog;
    args["is_performance_metrics"] = performanceMetrics;
    args["app_version"] = appVersion;

    await channel.invokeMethod<void>('initialize', args);
  }

  static Future<void> logEvent(
    String event, {
    Map<String, String> parameters,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args["event"] = event;
    args["parameters"] = parameters ?? <String, String>{};

    await channel.invokeMethod<void>('logEvent', args);
  }

  static Future<void> endTimedEvent(String event) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args["event"] = event;

    await channel.invokeMethod<void>('endTimedEvent', args);
  }

  static Future<void> setUserId(String userId) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args["userId"] = userId;

    await channel.invokeMethod<void>('userId', args);
  }
}
