import 'package:flutter/material.dart';
import '../../helpers/member_helper.dart';

/// Member avatar widget with initials
class MemberAvatar extends StatelessWidget {
  final String name;
  final double size;
  final String? imageUrl;
  final bool showBorder;

  const MemberAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.imageUrl,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = MemberHelper.getMemberColor(name);
    final initials = MemberHelper.getInitials(name);

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16)),
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        child: imageUrl == null
            ? Text(
                initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      );
    }

    return avatar;
  }
}
