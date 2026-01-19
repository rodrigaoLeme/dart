import 'package:flutter/material.dart';

import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';

class FormsDetailsTabs extends StatelessWidget {
  final FormsDetailsViewModel? viewModel;
  const FormsDetailsTabs({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final openCount = viewModel?.data?.localForms?.length ?? 0;
    final sentCount = viewModel?.data?.latestFormSended?.length ?? 0;
    return TabBar(
      indicatorColor: AdraColors.primary,
      labelColor: AdraColors.primary,
      unselectedLabelColor: AdraColors.neutralLowDark,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      tabs: [
        Tab(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Text(
                R.string.openLabel.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Positioned(
                top: -22,
                right: -20,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AdraColors.cyanBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$openCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AdraColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Tab(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Text(
                R.string.sentLabel.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Positioned(
                top: -22,
                right: -24,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AdraColors.cyanBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$sentCount',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AdraColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
