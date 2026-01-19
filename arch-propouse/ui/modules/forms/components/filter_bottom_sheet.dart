import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';
import '../forms_presenter.dart';

class FilterBottomSheet extends StatefulWidget {
  final FormsPresenter presenter;
  final FilterType filterType;
  final List<String> availableFilters;
  final List<String> currentSelections;

  const FilterBottomSheet({
    super.key,
    required this.presenter,
    required this.filterType,
    required this.availableFilters,
    required this.currentSelections,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.currentSelections);
  }

  String _getTitle() {
    switch (widget.filterType) {
      case FilterType.group:
        return R.string.selectGroup;
      case FilterType.project:
        return R.string.selectProject;
      case FilterType.form:
        return R.string.selectForm;
      case FilterType.all:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: AdraColors.greyLigth,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdraText(
                  text: _getTitle(),
                  textSize: AdraTextSizeEnum.h4,
                  textStyleEnum: AdraTextStyleEnum.semibold,
                  color: AdraColors.secondary,
                  adraStyles: AdraStyles.poppins,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AdraColors.secundary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Lista de opções
          Flexible(
            child: widget.availableFilters.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: AdraText(
                      text: R.string.noFiltersAvailable,
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.regular,
                      color: AdraColors.secundary,
                      adraStyles: AdraStyles.poppins,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.availableFilters.length,
                    itemBuilder: (context, index) {
                      final value = widget.availableFilters[index];
                      final isSelected = _selectedValues.contains(value);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedValues.remove(value);
                            } else {
                              _selectedValues.add(value);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AdraColors.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: AdraText(
                                  text: value,
                                  textSize: AdraTextSizeEnum.body,
                                  textStyleEnum: isSelected
                                      ? AdraTextStyleEnum.semibold
                                      : AdraTextStyleEnum.regular,
                                  color: isSelected
                                      ? AdraColors.primary
                                      : AdraColors.secondary,
                                  adraStyles: AdraStyles.poppins,
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AdraColors.primary,
                                  size: 24.0,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Botões de ação
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      side: const BorderSide(color: AdraColors.greyLigth),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: AdraText(
                      text: R.string.cancel,
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.semibold,
                      color: AdraColors.secundary,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.presenter
                          .addFilterValues(widget.filterType, _selectedValues);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdraColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: AdraText(
                      text: 'OK',
                      textSize: AdraTextSizeEnum.body,
                      textStyleEnum: AdraTextStyleEnum.semibold,
                      color: Colors.white,
                      adraStyles: AdraStyles.poppins,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
