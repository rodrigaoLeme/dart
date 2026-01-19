import 'dart:async';

import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';
import '../forms_presenter.dart';
import 'filter_bottom_sheet.dart';

class FilterSection extends StatefulWidget {
  final FormsPresenter presenter;

  const FilterSection({super.key, required this.presenter});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  final TextEditingController _searchController = TextEditingController();
  FilterType _selectedType = FilterType.all;
  List<String> _availableFilters = [];
  Map<FilterType, List<String>> _allSelectedFilters = {
    FilterType.group: [],
    FilterType.project: [],
    FilterType.form: [],
  };
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Atualiza o UI para mostrar/esconder o botão clear

      // Cancelar o timer anterior se existir
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      // Criar novo timer para debounce de 300ms
      _debounce = Timer(const Duration(milliseconds: 300), () {
        widget.presenter.setSearchText(_searchController.text);
      });
    });

    // Escutar mudanças nos filtros disponíveis
    widget.presenter.availableFiltersStream.listen((filters) {
      if (mounted) {
        setState(() {
          _availableFilters = filters;
        });
      }
    });

    // Escutar mudanças em todos os filtros selecionados
    widget.presenter.allSelectedFiltersStream.listen((filters) {
      if (mounted) {
        setState(() {
          _allSelectedFilters = filters;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _getFilterTypeLabel(FilterType type) {
    switch (type) {
      case FilterType.all:
        return R.string.filterAll;
      case FilterType.group:
        return R.string.filterGroup;
      case FilterType.project:
        return R.string.filterProject;
      case FilterType.form:
        return R.string.filterForm;
    }
  }

  void _handleFilterTypeChange(FilterType? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectedType = newValue;
    });

    if (newValue == FilterType.all) {
      // Não faz nada, apenas mostra resumo de todos os filtros
      return;
    }

    // Definir tipo e aguardar filtros disponíveis antes de abrir bottomsheet
    widget.presenter.setFilterType(newValue);

    // Aguardar um frame para garantir que os filtros foram atualizados
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _openFilterBottomSheet();
      }
    });
  }

  void _openFilterBottomSheet() {
    final currentSelections = _allSelectedFilters[_selectedType] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        presenter: widget.presenter,
        filterType: _selectedType,
        availableFilters: _availableFilters,
        currentSelections: currentSelections,
      ),
    );
  }

  List<Widget> _buildFilterChipsFromMap(
      Map<FilterType, List<String>> filters, FilterType type, String label) {
    final values = filters[type] ?? [];
    if (values.isEmpty) return [];

    return [
      const SizedBox(height: 8.0),
      AdraText(
        text: label,
        textSize: AdraTextSizeEnum.caption1,
        textStyleEnum: AdraTextStyleEnum.semibold,
        color: AdraColors.secundary,
        adraStyles: AdraStyles.poppins,
      ),
      const SizedBox(height: 4.0),
      Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: values.map((value) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: AdraColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AdraColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AdraText(
                    text: value,
                    textSize: AdraTextSizeEnum.body,
                    textStyleEnum: AdraTextStyleEnum.semibold,
                    color: AdraColors.primary,
                    adraStyles: AdraStyles.poppins,
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    widget.presenter.removeFilterValue(type, value);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 18.0,
                    color: AdraColors.primary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<FilterType, List<String>>>(
      stream: widget.presenter.allSelectedFiltersStream,
      initialData: _allSelectedFilters,
      builder: (context, snapshot) {
        final currentFilters = snapshot.data ?? _allSelectedFilters;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de busca
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: R.string.searchHint,
                  prefixIcon:
                      const Icon(Icons.search, color: AdraColors.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AdraColors.greyLigth),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AdraColors.greyLigth),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: AdraColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                ),
              ),
              const SizedBox(height: 16.0),

              // Dropdown de tipo de filtro
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AdraColors.greyLigth),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FilterType>(
                    value: _selectedType,
                    isExpanded: true,
                    items: FilterType.values.map((type) {
                      return DropdownMenuItem<FilterType>(
                        value: type,
                        child: AdraText(
                          text: _getFilterTypeLabel(type),
                          textSize: AdraTextSizeEnum.body,
                          textStyleEnum: AdraTextStyleEnum.regular,
                          color: AdraColors.secondary,
                          adraStyles: AdraStyles.poppins,
                        ),
                      );
                    }).toList(),
                    onChanged: _handleFilterTypeChange,
                  ),
                ),
              ),

              // Mostrar todos os valores selecionados agrupados por tipo
              if (currentFilters.values.any((list) => list.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._buildFilterChipsFromMap(currentFilters,
                          FilterType.group, R.string.filterGroup),
                      ..._buildFilterChipsFromMap(currentFilters,
                          FilterType.project, R.string.filterProject),
                      ..._buildFilterChipsFromMap(
                          currentFilters, FilterType.form, R.string.filterForm),
                      const SizedBox(height: 8.0),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedType = FilterType.all;
                          });
                          widget.presenter.clearAllFilters();
                        },
                        icon: const Icon(Icons.clear_all, size: 16.0),
                        label: const Text('Limpar todos os filtros'),
                        style: TextButton.styleFrom(
                          foregroundColor: AdraColors.secundary,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
