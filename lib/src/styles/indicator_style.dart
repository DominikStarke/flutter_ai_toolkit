import 'package:flutter/widgets.dart';
import 'toolkit_colors.dart';

@immutable
class IndicatorStyle {
  /// Creates a IndicatorStyle.
  const IndicatorStyle({
    this.color = ToolkitColors.darkIcon,
    this.decoration = const BoxDecoration(),
    this.size = 48.0,
    this.padding = const EdgeInsets.all(8.0),
    this.fontSize = 24.0,
    this.dotSpacing = 0.0,
    this.numberOfDots = 3,
    this.milliseconds = 250,
  });

  /// Resolves the IndicatorStyle by combining the provided style with
  /// default values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses
  /// [IndicatorStyle.defaultStyle].
  ///
  /// [style] - The custom IndicatorStyle to apply. Can be null.
  /// [defaultStyle] - The default IndicatorStyle to use as a base. If
  /// null, uses [IndicatorStyle.defaultStyle].
  ///
  /// Returns a new [IndicatorStyle] instance with resolved properties.
  factory IndicatorStyle.resolve(
    IndicatorStyle? style, {
    IndicatorStyle? defaultStyle,
  }) {
    defaultStyle ??= IndicatorStyle.defaultStyle();
    return IndicatorStyle(
      decoration: style?.decoration ?? defaultStyle.decoration,
      size: style?.size ?? defaultStyle.size,
      padding: style?.padding ?? defaultStyle.padding,
      fontSize: style?.fontSize ?? defaultStyle.fontSize,
      color: style?.color ?? ToolkitColors.enabledText,
      dotSpacing: style?.dotSpacing ?? defaultStyle.dotSpacing,
    );
  }

  /// Provides a default style.
  factory IndicatorStyle.defaultStyle() =>
      IndicatorStyle._lightStyle();

  /// Provides a default light style.
  factory IndicatorStyle._lightStyle() => IndicatorStyle(
        decoration: const BoxDecoration(
          color: ToolkitColors.fileContainerBackground,
          shape: BoxShape.rectangle,
        ),
        color: ToolkitColors.darkIcon,
      );

  /// Decoration for the action button bar.
  final Decoration decoration;

  /// Size of the dot indicator.
  final double size;

  /// Padding around the dot indicator.
  final EdgeInsetsGeometry padding;

  /// Number of dots that are added in a horizontal list, default = 3.
  final int numberOfDots;

  /// Font size of each dot, default = 24.0.
  final double fontSize;

  /// Spacing between each dot, default 0.0.
  final double dotSpacing;

  /// Color of the dots, default black.
  final Color color;

  /// Time of one complete cycle of animation, default 250 milliseconds.
  final int milliseconds;
}