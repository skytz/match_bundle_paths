#import "MatchBundlePathsPlugin.h"
#if __has_include(<match_bundle_paths/match_bundle_paths-Swift.h>)
#import <match_bundle_paths/match_bundle_paths-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "match_bundle_paths-Swift.h"
#endif

@implementation MatchBundlePathsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMatchBundlePathsPlugin registerWithRegistrar:registrar];
}
@end
