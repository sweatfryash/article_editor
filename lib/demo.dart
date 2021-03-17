import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with WidgetsBindingObserver {
  FocusNode _focusNode;
  bool isKeyboardActived = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // 创建一个界面变化的观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Editor'),
        ),
        body: Center(
          child: TextField(
            focusNode: _focusNode,
            onSubmitted: (_){
              isKeyboardActived = false;
            },
          ),
        ),
      ),
    );
  }
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    print('---ddd');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 当前是安卓系统并且在焦点聚焦的情况下
      if (Platform.isAndroid && _focusNode.hasFocus) {
        if (isKeyboardActived) {
          isKeyboardActived = false;
          // 使输入框失去焦点
          _focusNode.unfocus();
          return;
        }
        isKeyboardActived = true;
      }
    });
  }

}
