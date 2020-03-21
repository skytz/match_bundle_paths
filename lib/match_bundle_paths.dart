import 'dart:async';

import 'package:flutter/services.dart';

class MatchBundlePaths {
  static const MethodChannel _channel =
      const MethodChannel('match_bundle_paths');

  static Future<List<String>> matchBundlePaths({String regex}) async {
    final List<dynamic> results =
        await _channel.invokeMethod("matchBundlePaths", regex);
    return results.map((e) => e as String).toList();
  }
}
