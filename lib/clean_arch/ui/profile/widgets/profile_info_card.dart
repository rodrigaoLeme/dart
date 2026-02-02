import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/shared/localize.dart';
import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/auth/auth.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserEntity user;
  const ProfileInfoCard({super.key, required this.user});

  String _getProviderName() {
    if (user.providerId == null) return 'Desconhecido';

    switch (user.providerId) {
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      default:
        return user.providerId!;
    }
  }

  Widget _optionTile(
      String icon, String title, String trailingTitle, Function? onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  onTap();
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppStyle.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/$icon',
                  height: 20,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Txt.b(
                    title,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Txt(
                  trailingTitle,
                  size: 16,
                  color: Colors.white,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: [
          if (user.displayName != null) ...[
            Txt.b(
              user.displayName!,
              size: 24,
              color: AppStyle.primaryColor,
              align: TextAlign.center,
            ),
          ],
          if (user.email != null) ...[
            Txt(
              user.email!,
              size: 16,
              color: AppStyle.primaryColor,
              align: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
          ],
          _optionTile('seal.png', localize('authenticatedProvider'),
              _getProviderName(), null),
        ],
      ),
    );
  }
}
