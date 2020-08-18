#import "FlutterFlurrySdkPlugin.h"
#if __has_include(<flutter_flurry_sdk/flutter_flurry_sdk-Swift.h>)
#import <flutter_flurry_sdk/flutter_flurry_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_flurry_sdk-Swift.h"
#endif

@implementation FlutterFlurrySdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFlurrySdkPlugin registerWithRegistrar:registrar];
}
@end
