import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownFragment extends ChatMessageFragment {
  String text;

  MarkdownFragment({
    this.text = ''
  });

  @override
  Widget builder(BuildContext context) {
    return Markdown(data: text, shrinkWrap: true);
  }
}
