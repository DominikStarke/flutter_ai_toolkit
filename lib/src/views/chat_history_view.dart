// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/chat_view_model/chat_view_model.dart';
import 'package:flutter_ai_toolkit/src/chat_view_model/chat_view_model_provider.dart';

import '../providers/interface/chat_message.dart';
import '../providers/interface/message_origin.dart';
import 'chat_message_view/chat_message_view.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// A widget that displays a history of chat messages.
///
/// This widget renders a scrollable list of chat messages, supporting
/// selection and editing of messages. It displays messages in reverse
/// chronological order (newest at the bottom).
@immutable
class ChatHistoryView extends StatefulWidget {
  /// Creates a [ChatHistoryView].
  ///
  /// FIXME: if a message is editable should be decided by the provider / message, not the view.
  /// If [onEditMessage] is provided, it will be called when a user initiates an
  /// edit action on an editable message (typically the last user message in the
  /// history).
  const ChatHistoryView({
    this.onEditMessage,
    super.key,
  });

  /// Optional callback function for editing a message.
  ///
  /// If provided, this function will be called when a user initiates an edit
  /// action on an editable message (typically the last user message in the
  /// history). The function receives the [ChatMessage] to be edited as its
  /// parameter.
  final void Function(ChatMessage message)? onEditMessage;

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  final ScrollController controller = ScrollController();
  final ListController listController = ListController();
  late ChatViewModel viewModel = ChatViewModelProvider.of(context);

  bool keepScroll = false;

  @override
  initState() {
    super.initState();
    controller.addListener(() {
      keepScroll = controller.offset == 0;
    });
  }

  @override
  void didUpdateWidget(covariant ChatHistoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(keepScroll) {
        controller.jumpTo(0);
      }
    });

    viewModel = ChatViewModelProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final chatStyle = viewModel.style;

    final history = [
      if (viewModel.welcomeMessage != null)
        ChatMessage(
          origin: MessageOrigin.llm,
          text: viewModel.welcomeMessage,
          attachments: [],
        ),
      ...viewModel.provider.history,
    ];

    return SuperListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: chatStyle?.spacing ?? 8),
      reverse: true,
      padding: EdgeInsets.only(top: 56, left: 8, right: 8, bottom: 8),
      itemCount: history.length,
      itemBuilder: (context, index) => ChatMessageView(
        history[history.length - index  - 1],
        onEdit: () => widget.onEditMessage?.call(history[history.length - index  - 1])
      )
    );
  } 
}
