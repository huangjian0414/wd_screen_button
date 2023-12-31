library wd_screen_button;

import 'package:flutter/material.dart';

typedef WDScreenButtonCallBack = void Function();

class WDScreenButton {

  static OverlayEntry? _overlayEntry;
  ///是否显示
  static bool isShow = false;
  static WDScreenButtonCallBack? _callBack;
  static GlobalKey<NavigatorState>? _globalKey;

  static double _dx = 30;
  static double _dy = 100;
  static Widget? _buttonChild;
  ///是否初始化
  static bool isInit = false;

  ///显示/隐藏按钮
  static changeStatus(bool status){
    isShow = status;
    Future.delayed(const Duration(milliseconds: 330)).then((value) {
      _overlayEntry?.markNeedsBuild();
    });
  }
  static initConfig(GlobalKey<NavigatorState> globalKey,{double left = 30, double top = 100,
    bool isShowBtn = false,Widget? buttonChild,WDScreenButtonCallBack? callBack}){
    if(isInit){
      return;
    }
    isShow = isShowBtn;
    _callBack = callBack;
    _dx = left;
    _dy = top;
    _buttonChild = buttonChild;
    _globalKey = globalKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  ///初始化
  static _init()  {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          top:  _dy,
          left: _dx,
          child: GestureDetector(
              onTap: () {
                if (_callBack != null) {
                  _callBack!();
                }
              },
              child: Offstage(
                offstage: !isShow,
                child: Draggable(
                    onDragUpdate: (DragUpdateDetails details){
                    },
                    onDragEnd: (DraggableDetails details) {
                      ///拖动结束
                      _dx = details.offset.dx;
                      _dy = details.offset.dy;
                      if (_dx < 30) {
                        _dx = 30;
                      } else if (_dx > MediaQuery.of(context).size.width - 30) {
                        _dx = MediaQuery.of(context).size.width-30;
                      }
                      if (_dy < 100) {
                        _dy = 100;
                      }else if (_dy > MediaQuery.of(context).size.height - 100) {
                        _dy = MediaQuery.of(context).size.height - 100;
                      }
                      _overlayEntry?.markNeedsBuild();
                    },
                    childWhenDragging: const SizedBox.shrink(),
                    feedback: _buttonChild ?? const Icon(Icons.pest_control_sharp,size: 40,color: Colors.blueAccent,),
                    child:_buttonChild ?? const Icon(Icons.pest_control_sharp,size: 40,color: Colors.blueAccent)),
              )
          ),
        )
    );
    if (_globalKey?.currentState?.overlay != null) {
      _globalKey!.currentState!.overlay!.insert(_overlayEntry!);
      isInit = true;
    }
  }


}
