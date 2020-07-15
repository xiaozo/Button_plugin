//
//  ButtonFactory.m
//  button
//
//  Created by DeerClass on 2020/7/15.
//

#import "ButtonFactory.h"
#import "UIColor+RGB.h"
@implementation ButtonFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}


- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    ButtonController*activity = [[ButtonController alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
   
   return activity;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}


@end

@implementation ButtonController{
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    UIButton * _button;
}

- (instancetype)initWithWithFrame:(CGRect)frame
 viewIdentifier:(int64_t)viewId
      arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        
        NSDictionary *dic = args;
        NSString *text = dic[@"text"];
        NSString *hexColor = dic[@"hexColor"];
      
        _button = [[UIButton alloc]initWithFrame:frame];
        [_button setTitle:text forState:UIControlStateNormal];
        if (hexColor.length) {
            _button.backgroundColor = [UIColor colorWithHexString:hexColor];;
        }
       
        [_button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"plugins.metre.com/button_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
       
    }
    
    return self;
}

-(UIView *)view{
    return _button;
}

#pragma mark - target
- (void)tapAction {
    [_channel invokeMethod:@"onClickListener" arguments:nil];
}

@end
