import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownFragment {
  String text;
  GlobalKey? key;

  MarkdownFragment({this.text = '', this.key});

  Widget builder(BuildContext context) {
    return Markdown(data: text, shrinkWrap: true, key: key);
  }
}
