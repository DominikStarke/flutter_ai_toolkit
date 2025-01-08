import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../styles/llm_chat_view_style.dart';
import '../../utility.dart';

/// A widget that displays hovering buttons for editing and copying.
///
/// This widget is a [StatefulWidget] that shows buttons for editing and copying
/// when the user hovers over the child widget. The buttons are displayed at the
/// bottom right of the child widget.
class HoveringButtons extends StatelessWidget {
  /// Creates a [HoveringButtons] widget.
  ///
  /// The [onEdit] callback is invoked when the edit button is pressed. The
  /// [child] widget is the content over which the buttons will hover.
  HoveringButtons({
    required this.chatStyle,
    required this.isUserMessage,
    required this.child,
    this.clipboardText,
    this.onEdit,
    super.key,
  });

  /// The style information for the chat.
  final LlmChatViewStyle chatStyle;

  /// Whether the message is a user message.
  final bool isUserMessage;

  /// The text to be copied to the clipboard.
  final String? clipboardText;

  /// The child widget over which the buttons will hover.
  final Widget child;

  /// The callback to be invoked when the edit button is pressed.
  final VoidCallback? onEdit;

  static const _iconSize = 12;
  final _hovering = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {

    return MouseRegion(
      onEnter: (_) => _hovering.value = true,
      onExit: (_) => _hovering.value = false,
      child: ListenableBuilder(
        listenable: _hovering,
        child: child,
        builder: (context, child) {
          if (!_hovering.value) {
            return Padding(
              padding: const EdgeInsets.only(bottom: _iconSize + 8),
              child: child!,
            );
          }

          return Column(
            crossAxisAlignment: isUserMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              child!,
              Row(
                mainAxisAlignment: isUserMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
                spacing: 6,
                children: [

                  if (onEdit != null) IconButton(
                    constraints: BoxConstraints(maxHeight: _iconSize + 8),
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    icon: Icon(
                      chatStyle.editButtonStyle!.icon,
                      size: _iconSize.toDouble(),
                      color: chatStyle.editButtonStyle!.iconColor,
                    ),
                    onPressed: onEdit,
                  ),

                  IconButton(
                    constraints: BoxConstraints(maxHeight: _iconSize + 8),
                    style: ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(4)),
                      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    icon: Icon(
                      chatStyle.copyButtonStyle!.icon,
                      size: _iconSize.toDouble(),
                      color: chatStyle.copyButtonStyle!.iconColor,
                    ),
                    onPressed: () => unawaited(
                      copyToClipboard(context, clipboardText!),
                    ),
                  )

                ],
              ),
            ],
          );
        }
      ),
    );


  }
}
