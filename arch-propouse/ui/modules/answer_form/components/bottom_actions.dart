import 'package:flutter/material.dart';

import '../../../components/adra_button.dart';
import '../../../components/components.dart';
import '../../../components/shimmer.dart';
import '../../../helpers/i18n/resources.dart';

class BottomActions extends StatelessWidget {
  final bool isFirstTab;
  final bool isSaveState;
  final bool isSubmitting;
  final VoidCallback onPrevious;
  final Future<void> Function() onNextOrFinalize;
  final Future<void> Function() onSaveDraft;

  const BottomActions({
    super.key,
    required this.isFirstTab,
    required this.isSaveState,
    required this.isSubmitting,
    required this.onPrevious,
    required this.onNextOrFinalize,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
          child: Row(
            children: [
              Flexible(
                child: AdraButton(
                  onPressed: (isFirstTab || isSubmitting) ? null : onPrevious,
                  title: R.string.backLabel,
                  buttonColor: AdraColors.hintColor,
                  borderRadius: 50.0,
                  buttonHeigth: 52.0,
                  titleColor:
                      isFirstTab ? AdraColors.secundary : AdraColors.primary,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: isSaveState && isSubmitting
                    ? Shimmer(
                        baseColor: AdraColors.primary.withOpacity(0.6),
                        highlightColor: AdraColors.white.withOpacity(0.4),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: AdraColors.primary,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            R.string.finalizeRegistration,
                            style: const TextStyle(
                              color: AdraColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : AdraButton(
                        onPressed: isSubmitting
                            ? null
                            : () async {
                                await onNextOrFinalize();
                              },
                        title: isSaveState
                            ? R.string.finalizeRegistration
                            : R.string.next,
                        buttonColor: AdraColors.primary,
                        borderRadius: 50.0,
                        buttonHeigth: 52.0,
                        titleColor: AdraColors.white,
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 12.0, left: 16.0, right: 16.0, bottom: 32.0),
          child: Center(
            child: AdraButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      await onSaveDraft();
                    },
              title: R.string.saveDraftLabel,
              buttonColor: AdraColors.hintColor,
              borderRadius: 50.0,
              buttonHeigth: 52.0,
              titleColor: AdraColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
