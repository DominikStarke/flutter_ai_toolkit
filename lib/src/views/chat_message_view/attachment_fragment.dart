import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_ai_toolkit/src/views/attachment_view/attachment_view.dart';

class AttachmentFragment extends ChatMessageFragment {
  final Attachment attachment;
  final LlmChatViewStyle chatStyle;

  AttachmentFragment({
    required this.attachment,
    required this.chatStyle,
  });

  @override
  Widget builder(BuildContext context) {
    return AttachmentView(attachment);
  }
}
