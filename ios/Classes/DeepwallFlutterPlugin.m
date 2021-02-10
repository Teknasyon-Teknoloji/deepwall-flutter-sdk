#import "DeepwallFlutterPlugin.h"
#if __has_include(<deepwall_flutter_plugin/deepwall_flutter_plugin-Swift.h>)
#import <deepwall_flutter_plugin/deepwall_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "deepwall_flutter_plugin-Swift.h"
#endif

@implementation DeepwallFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeepwallFlutterPlugin registerWithRegistrar:registrar];
}
@end
