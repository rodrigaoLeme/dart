import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/shared/localize.dart';
import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

class AnonymousInfoCard extends StatelessWidget {
  final VoidCallback onLearnMore;

  const AnonymousInfoCard({super.key, required this.onLearnMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppStyle.primaryColor,
                size: 24,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Txt.b(
                  localize('anonymousUser'),
                  size: 18,
                  color: AppStyle.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Txt(
                  localize('anonymousMessage'),
                  color: AppStyle.primaryColor,
                  style: const TextStyle(
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              InkWell(
                onTap: onLearnMore,
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 24,
                      color: AppStyle.primaryColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      localize('anonymousReadMore'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppStyle.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
