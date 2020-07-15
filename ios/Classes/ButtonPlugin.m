#import "ButtonPlugin.h"
#import "ButtonFactory.h"

@implementation ButtonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"button_plugin"
            binaryMessenger:[registrar messenger]];
  ButtonPlugin* instance = [[ButtonPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    [registrar registerViewFactory:[[ButtonFactory alloc] initWithMessenger:registrar.messenger] withId:@"plugins.metre.com/button"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"testM" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
      } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
