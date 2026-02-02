import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String? displayName;
  final double size;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.displayName,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: AppStyle.primaryColor,
      );
    }

    if (displayName != null && displayName!.isNotEmpty) {
      final initial = displayName![0].toUpperCase();
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: AppStyle.primaryColor,
        child: Txt.b(
          initial,
          size: size / 2.5,
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: AppStyle.primaryColor,
      child: Icon(
        Icons.person,
        size: size / 2,
        color: Colors.white,
      ),
    );
  }
}
