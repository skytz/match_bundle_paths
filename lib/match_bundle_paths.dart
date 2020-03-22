import 'dart:async';
import 'package:flutter/services.dart';

class MatchBundlePaths {
  static const MethodChannel _channel =
      const MethodChannel('match_bundle_paths');

  static Future<List<String>> matchBundlePaths({RegExp regex}) async {
    final List<dynamic> results =
        await _channel.invokeMethod("matchBundlePaths", regex.pattern);
    return results.map((e) {
      var string = e as String;

      return string;
    }).toList();
  }

  static Future<String> matchFlutterAsset({
    RegExp regex,
  }) async {
    List<String> assets = await MatchBundlePaths.matchBundlePaths(
        regex: RegExp(".*flutter_assets.*${regex.pattern}.*"));
    if (assets.length >= 1) {
      return assets[0];
    }
    return "";
  }
}
