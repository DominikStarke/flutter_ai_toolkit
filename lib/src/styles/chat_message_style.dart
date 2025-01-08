// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'tookit_icons.dart';
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

/// Style for LLM messages.
@immutable
class ChatMessageStyle {
  /// Creates an LlmMessageStyle.
  const ChatMessageStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.decoration,
    this.markdownStyle,
    this.padding,
    this.flexSpace = 8,
  });

  /// Resolves the provided style with the default style.
  ///
  /// This method creates a new [ChatMessageStyle] by combining the provided
  /// [style] with the [defaultStyle]. If a property is not specified in the
  /// provided [style], it falls back to the corresponding property in the
  /// [defaultStyle].
  ///
  /// If [defaultStyle] is not provided, it uses [LlmMessageStyle.defaultStyle].
  ///
  /// Parameters:
  ///   - [style]: The custom style to apply. Can be null.
  ///   - [defaultStyle]: The default style to use as a fallback. If null, uses
  ///     [LlmMessageStyle.defaultStyle].
  ///
  /// Returns: A new [ChatMessageStyle] instance with resolved properties.
  factory ChatMessageStyle.resolve(
    ChatMessageStyle? style, {
    ChatMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= ChatMessageStyle.defaultLlmStyle();
    return ChatMessageStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
      markdownStyle: style?.markdownStyle ?? defaultStyle.markdownStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
      padding: style?.padding ?? defaultStyle.padding,
      flexSpace: style?.flexSpace ?? defaultStyle.flexSpace,
    );
  }

  /// Provides a default style.
  factory ChatMessageStyle.defaultLlmStyle() => ChatMessageStyle._lightStyle();
  factory ChatMessageStyle.defaultUserStyle() => ChatMessageStyle._lightStyle();

  /// Provides a default light style.
  factory ChatMessageStyle._lightStyle() => ChatMessageStyle(
        icon: ToolkitIcons.spark_icon,
        iconColor: ToolkitColors.darkIcon,
        iconDecoration: const BoxDecoration(
          color: ToolkitColors.llmIconBackground,
          shape: BoxShape.circle,
        ),
        markdownStyle: MarkdownStyleSheet(
          a: ToolkitTextStyles.body1,
          blockquote: ToolkitTextStyles.body1,
          checkbox: ToolkitTextStyles.body1,
          code: ToolkitTextStyles.code,
          del: ToolkitTextStyles.body1,
          em: ToolkitTextStyles.body1.copyWith(fontStyle: FontStyle.italic),
          h1: ToolkitTextStyles.heading1,
          h2: ToolkitTextStyles.heading2,
          h3: ToolkitTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          h4: ToolkitTextStyles.body1,
          h5: ToolkitTextStyles.body1,
          h6: ToolkitTextStyles.body1,
          listBullet: ToolkitTextStyles.body1,
          img: ToolkitTextStyles.body1,
          strong: ToolkitTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          p: ToolkitTextStyles.body1,
          tableBody: ToolkitTextStyles.body1,
          tableHead: ToolkitTextStyles.body1,
        ),
        decoration: BoxDecoration(
          color: ToolkitColors.llmMessageBackground,
          border: Border.all(
            color: ToolkitColors.llmMessageOutline,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(8),
        flexSpace: 12,
      );

  /// The icon to display for the LLM messages.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The decoration for LLM message bubbles.
  final Decoration? decoration;

  /// Padding inside the message, around the text.
  final EdgeInsetsGeometry? padding;

  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyle;

  /// [$1] the flex size for the space between messages.  
  /// 
  /// We assume flex 20 so messages takes `20 - flexSpace` flex spac..
  final int flexSpace;
}
