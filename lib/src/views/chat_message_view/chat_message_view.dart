// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/providers/interface/message_origin.dart';
import 'package:flutter_ai_toolkit/src/views/chat_message_view/attachment_fragment.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../providers/interface/chat_message.dart';
import '../../styles/llm_chat_view_style.dart';
import '../../styles/chat_message_style.dart';
import '../jumping_dots_progress_indicator/jumping_dots_progress_indicator.dart';
import 'adaptive_copy_text.dart';
import 'hovering_buttons.dart';

/// A widget that displays an LLM (Language Model) message in a chat interface.
@immutable
class ChatMessageView extends StatelessWidget {
  /// Creates an [ChatMessageView].
  ///
  /// The [message] parameter is required and represents the LLM chat message to
  /// be displayed.
  const ChatMessageView(
    this.message, {
    this.isWelcomeMessage = false,
    super.key,
    this.onEdit
  });

  /// The LLM chat message to be displayed.
  final ChatMessage message;

  /// Whether the message is the welcome message.
  final bool isWelcomeMessage;

  /// The callback to be invoked when the message is edited.
  final VoidCallback? onEdit;

  Widget _defaultBuilder (BuildContext context, ChatMessage message, ChatMessageStyle messageStyle, LlmChatViewStyle chatStyle) {
    return Column(
      crossAxisAlignment: message.origin == MessageOrigin.user
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
      children: [
        if(message.leading.isNotEmpty) Column(
          crossAxisAlignment: message.origin == MessageOrigin.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
          children: [
            for (final fragment in message.leading)
              fragment.builder(context),
          ]
        ),

        if(message.attachments.isNotEmpty) Column(
          children: [
            for (final attachment in message.attachments)
              AttachmentFragment(
                attachment: attachment,
                chatStyle: chatStyle
              ).builder(context),
          ]
        ),
      
        HoveringButtons(
          isUserMessage: message.origin == MessageOrigin.user,
          chatStyle: chatStyle,
          clipboardText: message.text,
          onEdit: onEdit,
          child: Container(
            decoration: messageStyle.decoration,
            child: AdaptiveCopyText(
              chatStyle: chatStyle,
              clipboardText: message.text,
              onEdit: onEdit,
              child: message.origin == MessageOrigin.user
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(message.text, style: messageStyle.textStyle),
                )
                : message.outlet.builder(context))
          ),
        ),
      
        if(message.trailing.isNotEmpty) Column(
          children: [
            for (final fragment in message.leading)
              fragment.builder(context),
          ]
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
    builder: (context, viewModel, child) {
      final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
      final messageStyle = ChatMessageStyle.resolve(
        message.origin == MessageOrigin.user
          ? chatStyle.userMessageStyle
          : chatStyle.llmMessageStyle,
      );
      return Row(
        mainAxisAlignment: message.origin == MessageOrigin.user
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
        children: [
          if(message.origin == MessageOrigin.user) const Flexible(flex: 2, child: SizedBox()),

          Flexible(
            flex: 6,
            child: message.isUninitialized()
              ? Container(
                  decoration: messageStyle.decoration,
                  width: 56,
                  height: 56,
                  child: JumpingDotsProgressIndicator(
                    fontSize: 24,
                    color: chatStyle.progressIndicatorColor!,
                  ),
                )
              : Builder(builder: (context)
                => viewModel.responseBuilder?.call(context, message)
                ?? _defaultBuilder(context, message, messageStyle, chatStyle),
              )
          ),

          if(message.origin == MessageOrigin.llm) const Flexible(flex: 2, child: SizedBox()),
        ],
      );
    }
  );
}
