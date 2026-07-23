import 'package:flutter/material.dart';

/// Onboarding page footer widget
class OnboardingFooter extends StatelessWidget {
  final Widget? leftWidget;
  final Widget? centerWidget;
  final Widget? rightWidget;
  final EdgeInsets? padding;

  const OnboardingFooter({
    super.key,
    this.leftWidget,
    this.centerWidget,
    this.rightWidget,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget ?? const SizedBox(width: 80),
          centerWidget ?? const SizedBox(),
          rightWidget ?? const SizedBox(width: 80),
        ],
      ),
    );
  }
}
