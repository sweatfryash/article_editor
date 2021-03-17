import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/models/documents/nodes/leaf.dart' as leaf;
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/default_styles.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:quill_delta/quill_delta.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  QuillController _quillController;
  ScrollController _scrollController;
  FocusNode _editorFocusNode;
  FocusNode _titleFocusNode;
  String docJson = r'''[{"insert":"粗体","attributes":{"bold":true}},
  {"insert":"666"},
  {"insert":"斜体","attributes":{"italic":true}},
  {"insert":"\n"},{"insert":"粗体","attributes":{"bold":true}},
  {"insert":"1213\n"},{"insert":"斜体","attributes":{"italic":true}},
  {"insert":"\n"},
  {"insert":"下划线","attributes":{"underline":true}},
  {"insert":"\n"}]''';

  @override
  void initState() {
    super.initState();
    /*_controller = QuillController(
        document: Document.fromJson(jsonDecode(docJson)),
        selection: TextSelection.collapsed(offset: 0));*/
    _quillController = QuillController.basic();
    _scrollController = ScrollController();
    _editorFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text('编辑',style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
          actions: [
            FlatButton(
              child: Text('发布'),
              onPressed: () {
                Delta delta = _quillController.document.toDelta();
                print(jsonEncode(delta.toList()));
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                focusNode: _titleFocusNode,
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Container(
                  child: QuillEditor(
                    controller: _quillController,
                    readOnly: false,
                    expands: false,
                    autoFocus: false,
                    scrollController: _scrollController,
                    scrollable: true,
                    focusNode: _editorFocusNode,
                    padding: const EdgeInsets.all(0),
                    enableInteractiveSelection: true,
                    embedBuilder: _embedBuilder,
                  ),
                ),
              ),
              _bottomBar()
            ],
          ),
        ));
  }
  Widget _bottomBar(){
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(-1, 0.0), //阴影xy轴偏移量
              blurRadius: 1.5, //阴影模糊程度
              spreadRadius: 2 //阴影扩散程度
          )]
        ),
        height: 45,
        child: Row(),
      ),
    );
  }
  Widget _embedBuilder(BuildContext context, leaf.Embed node) {
    switch (node.value.type) {
      case 'divider':
        final style = QuillStyles.getStyles(context, true);
        return Divider(
          height: style.paragraph.style.fontSize * style.paragraph.style.height,
          thickness: 2,
          color: Colors.grey.shade200,
        );
      case 'image':
        return Image.file(File(node.value.data));
      default:
        throw UnimplementedError(
            'Embeddable type "${node.value.type}" is not supported by default embed '
            'builder of QuillEditor. You must pass your own builder function to '
            'embedBuilder property of QuillEditor or QuillField widgets.');
    }
  }

  @override
  void dispose() {
    _editorFocusNode.dispose();
    super.dispose();
  }
}
