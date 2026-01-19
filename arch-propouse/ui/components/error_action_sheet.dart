import 'package:flutter/material.dart';

import '../../domain/entities/share/generic_error_entity.dart';
import '../helpers/extensions/array_extension.dart';
import '../helpers/i18n/resources.dart';
import '../helpers/responsive/responsive_layout.dart';
import 'adra_colors.dart';
import 'adra_text.dart';
import 'enum/adra_size_enum.dart';
import 'theme/adra_styles.dart';

class ErrorActionSheet extends StatelessWidget {
  final GenericErrorEntity? errorEntity;
  final void Function(GenericErrorEntity?) onPressed;
  const ErrorActionSheet({
    required this.errorEntity,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: errorEntity?.errors?.safeAt(0)?.sessions?.length ?? 0,
            itemBuilder: (context, index) {
              final viewModel =
                  errorEntity?.errors?.safeAt(0)?.sessions?[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  height: 48,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: AdraColors.hintColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AdraText(
                          text: viewModel?.title ?? '',
                          adraStyles: AdraStyles.poppins,
                          color: AdraColors.indicatorColor,
                          textSize: AdraTextSizeEnum.body,
                          textStyleEnum: AdraTextStyleEnum.regular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline,
                            color: AdraColors.indicatorColor),
                        onPressed: () {
                          if (viewModel?.error != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(R.string.detailsLabel),
                                  content: Text(viewModel?.error ?? ''),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onPressed(errorEntity);
                                      },
                                      child: Text(R.string.foxErrors),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(R.string.close),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static void showActionSheet(
    BuildContext context,
    GenericErrorEntity errorEntity,
    void Function(GenericErrorEntity?) onPressed,
  ) {
    showModalBottomSheet(
      backgroundColor: AdraColors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: SizedBox(
            height: ResponsiveLayout.of(context).hp(60),
            child: ErrorActionSheet(
              errorEntity: errorEntity,
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
}
