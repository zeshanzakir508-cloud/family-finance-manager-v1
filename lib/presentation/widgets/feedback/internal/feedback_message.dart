// lib/presentation/widgets/feedback/internal/feedback_message.dart

import 'package:flutter/material.dart';

import '../helpers/feedback_style_builder.dart';

/// Internal widget for rendering feedback message.
class FeedbackMessage extends StatelessWidget {
  final String title;
  final String? message;
  final FeedbackStyle style;
  final TextAlign textAlign;

  const FeedbackMessage({
    super.key,
    required this.title,
    this.message,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(
        title,
        style: style.titleStyle,
        textAlign: textAlign,
      ),
    ];

    if (message != null && message!.isNotEmpty) {
      children.add(const SizedBox(height: 8));
      children.add(
        Text(
          message!,
          style: style.messageStyle,
          textAlign: textAlign,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
