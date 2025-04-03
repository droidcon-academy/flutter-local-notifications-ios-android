import 'package:flutter/material.dart';

/// Theme extension for Timora app.
///
/// This extension provides additional theme properties specific to the Timora app.
class TimoraTheme extends ThemeExtension<TimoraTheme> {
  /// The border radius used for cards and containers.
  final double cardBorderRadius;
  
  /// The border radius used for buttons.
  final double buttonBorderRadius;
  
  /// The border radius used for text fields.
  final double textFieldBorderRadius;
  
  /// The elevation used for cards.
  final double cardElevation;
  
  /// The elevation used for buttons.
  final double buttonElevation;
  
  /// The padding used for cards.
  final EdgeInsetsGeometry cardPadding;
  
  /// The padding used for content areas.
  final EdgeInsetsGeometry contentPadding;
  
  /// Creates a Timora theme extension.
  ///
  /// All parameters have default values that match the app's design language.
  const TimoraTheme({
    this.cardBorderRadius = 16.0,
    this.buttonBorderRadius = 16.0,
    this.textFieldBorderRadius = 12.0,
    this.cardElevation = 1.0,
    this.buttonElevation = 0.0,
    this.cardPadding = const EdgeInsets.all(20.0),
    this.contentPadding = const EdgeInsets.all(20.0),
  });

  @override
  ThemeExtension<TimoraTheme> copyWith({
    double? cardBorderRadius,
    double? buttonBorderRadius,
    double? textFieldBorderRadius,
    double? cardElevation,
    double? buttonElevation,
    EdgeInsetsGeometry? cardPadding,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return TimoraTheme(
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      textFieldBorderRadius: textFieldBorderRadius ?? this.textFieldBorderRadius,
      cardElevation: cardElevation ?? this.cardElevation,
      buttonElevation: buttonElevation ?? this.buttonElevation,
      cardPadding: cardPadding ?? this.cardPadding,
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  ThemeExtension<TimoraTheme> lerp(ThemeExtension<TimoraTheme>? other, double t) {
    if (other is! TimoraTheme) {
      return this;
    }
    
    return TimoraTheme(
      cardBorderRadius: lerpDouble(cardBorderRadius, other.cardBorderRadius, t),
      buttonBorderRadius: lerpDouble(buttonBorderRadius, other.buttonBorderRadius, t),
      textFieldBorderRadius: lerpDouble(textFieldBorderRadius, other.textFieldBorderRadius, t),
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t),
      buttonElevation: lerpDouble(buttonElevation, other.buttonElevation, t),
      cardPadding: EdgeInsetsGeometry.lerp(cardPadding, other.cardPadding, t)!,
      contentPadding: EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t)!,
    );
  }
  
  /// Helper method to lerp double values.
  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  /// Light theme values for Timora.
  static const light = TimoraTheme();
  
  /// Dark theme values for Timora.
  static const dark = TimoraTheme();
}

/// Extension methods for ThemeData to easily access Timora theme properties.
extension TimoraThemeExtension on ThemeData {
  /// Gets the Timora theme extension from the current theme.
  TimoraTheme get timoraTheme => extension<TimoraTheme>() ?? TimoraTheme.light;
}
