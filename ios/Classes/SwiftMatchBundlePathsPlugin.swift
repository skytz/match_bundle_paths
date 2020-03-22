import Flutter
import UIKit

public class SwiftMatchBundlePathsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "match_bundle_paths", binaryMessenger: registrar.messenger())
    let instance = SwiftMatchBundlePathsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "matchBundlePaths" else {
        result(FlutterMethodNotImplemented)
        return
    }
    
    guard let regexPattern = call.arguments as? String else {
        result(FlutterError(code: "Argument", message: "Function call argument is not String", details: nil))
        return
    }
    
    guard let regex = try? NSRegularExpression(pattern: regexPattern) else {
        result(FlutterError(code: "Regex", message: "Regex expression error", details: nil))
        return
    }
    
    var matchedPaths: [String] = []
    let path = URL(fileURLWithPath: Bundle.main.bundlePath)
    if let enumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: [.isRegularFileKey], options: []) {
        for case let fileURL as URL in enumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                if fileAttributes.isRegularFile! {
                    let fileString = fileURL.absoluteString;
                    if regex.numberOfMatches(in: fileString, options: [], range: NSRange(location: 0, length: fileString.count)) > 0 {
                        if fileString.hasPrefix("file://") {
                            matchedPaths.append(String(fileString.dropFirst(7)));
                        } else {
                            matchedPaths.append(fileString);
                        }
                    }
                }
            } catch let error {
                result(FlutterError(code: "Match", message: error.localizedDescription, details: nil))
                return
            }
        }
    }
    result(matchedPaths);
  }
}
