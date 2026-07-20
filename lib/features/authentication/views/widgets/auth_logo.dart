import 'package:flutter/material.dart';

/// Authentication logo widget.
class AuthLogo extends StatelessWidget {
  final double size;

  const AuthLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Icon(
          Icons.attach_money,
          size: size * 0.5,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
