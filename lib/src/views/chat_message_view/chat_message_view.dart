// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_ai_toolkit/src/chat_view_model/chat_view_model_provider.dart';
import 'package:flutter_ai_toolkit/src/views/attachment_view/attachment_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

  @override
  Widget build(BuildContext context) {
    /// Subtract with [ChatMessageStyle.flexSpace] to calculate message and white space flex.
    final flexMax = 20;
    final viewModel = ChatViewModelProvider.of(context);
    final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
    final isUserMessage = message.origin == MessageOrigin.user;
    final isLlmMessage = message.origin == MessageOrigin.llm;
    final messageStyle = ChatMessageStyle.resolve(
      isUserMessage
        ? chatStyle.userMessageStyle
        : chatStyle.llmMessageStyle,
    );

    bool isEmptyMessage = message.text?.isEmpty ?? true;
    
    return Row(
      mainAxisAlignment: isUserMessage
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isUserMessage) Flexible(
          flex: flexMax - messageStyle.flexSpace,
          child: SizedBox()
        ),

        if(isLlmMessage) Container(
          height: 32,
          width: 32,
          margin: EdgeInsets.only(right: 8),
          decoration: messageStyle.iconDecoration,
          child: Icon(
            messageStyle.icon,
            color: messageStyle.iconColor,
            size: 24,
          ),
        ),

        Flexible(
          flex: messageStyle.flexSpace,

          child: Column(
            crossAxisAlignment: isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
            children: [
              if (isEmptyMessage) Container(
                decoration: messageStyle.decoration,
                child: JumpingDotsProgressIndicator(
                  size: chatStyle.indicatorStyle!.size,
                  fontSize: chatStyle.indicatorStyle!.fontSize,
                  color: chatStyle.indicatorStyle!.color,
                  dotSpacing: chatStyle.indicatorStyle!.dotSpacing,
                  milliseconds: chatStyle.indicatorStyle!.milliseconds,
                  numberOfDots: chatStyle.indicatorStyle!.numberOfDots,
                ),
              ),

              if(!isEmptyMessage && message.attachments.isNotEmpty) Column(
                children: [
                  for (final attachment in message.attachments)
                    AttachmentView(attachment),
                ]
              ),

              if(!isEmptyMessage) HoveringButtons(
                isUserMessage: isUserMessage,
                chatStyle: chatStyle,
                clipboardText: message.text,
                onEdit: onEdit,
                child: Container(
                  padding: messageStyle.padding,
                  decoration: messageStyle.decoration,
                  child: AdaptiveCopyText(
                    chatStyle: chatStyle,
                    clipboardText: message.text ?? "",
                    onEdit: onEdit,
                    child: Builder(
                      builder: (context) {
                        if(isLlmMessage && viewModel.responseBuilder != null) {
                          return viewModel.responseBuilder!(context, message);
                        } else { // if (isUserMessage && viewModel.requestBuilder != null) {
                          return MarkdownBody(
                            data: message.text ?? "",
                            selectable: true,
                            styleSheet: messageStyle.markdownStyle,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        ),

        if(isLlmMessage) Flexible(
          flex: flexMax - messageStyle.flexSpace,
          child: SizedBox()
        ),
      ],
    );
  }
}
