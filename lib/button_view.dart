import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//自定义一个OnClickListener回调
typedef void OnClickListener(Widget view);
typedef void ButtonCreatedCallback(ButtonController controller);

//自定Flutter可以调用的ButtonWidget
class Buttons extends StatefulWidget {
  //定义属性
  final String text;
  final String hexColor;
  //final double width;
  //final double height;

  //定义一个点击事件
  final OnClickListener onListener;
  //定义一个回调
  final ButtonCreatedCallback onButtonCreatedCallback;

  // 实现一个构造函数 text,width,height 为必传
  const Buttons({Key key,
    @required this.text,
    this.hexColor,
    this.onListener,
    this.onButtonCreatedCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    //安卓平台
    if (defaultTargetPlatform == TargetPlatform.android) {

      //AndroidView 是包装原生View的关键widget
      return new AndroidView(
          viewType: 'plugins.metre.com/button',  // 自定义唯一viewType
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: _creationParams(),
          creationParamsCodec: const StandardMessageCodec()//如果设置了creationParams参数，必须要设置creationParamsCodec
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      print("TargetPlatform.iOS");
      return UiKitView(
        viewType: "plugins.metre.com/button",
        onPlatformViewCreated:_onPlatformViewCreated,
        creationParams: _creationParams(),
        creationParamsCodec: new StandardMessageCodec(),

      );
    }
    //该插件暂时还不支持该平台
    return Text(
        '$defaultTargetPlatform is not yet supported by the the button plugin!');
  }

  //封装参数
  Map<String, dynamic> _creationParams() {
    return <String, dynamic>{
      'text': widget.text,
      "hexColor":widget.hexColor,
    };
  }


  void _onPlatformViewCreated(int id) {
    ButtonController controller = ButtonController._(id, widget);
    if (widget.onButtonCreatedCallback != null){
      widget.onButtonCreatedCallback(controller);
    }
  }
}

//Button回调控制
class ButtonController {

  final MethodChannel _channel;
  final Buttons _widget;
  ButtonController._(int id, this._widget,) : _channel = MethodChannel('plugins.metre.com/button_$id'){
    _channel.setMethodCallHandler(_methodCallHandler);
  }
  Future<bool> _methodCallHandler(MethodCall call) {
    switch (call.method) {
    ///实现onClickListener方法,给原生调用
      case 'onClickListener':
        _widget.onListener(_widget);
        return null;
    }
    //没有该回调，抛异常
    throw MissingPluginException(
        '${call.method} was invoked but has no handler!');
  }
}