import 'package:flutter/material.dart';

import '../../models/cep_model.dart';
import 'cep_information_expansion_item.dart';

class BairroInformation extends StatelessWidget {
  const BairroInformation({
    super.key,
    required this.cep,
  });

  final CepModel cep;

  @override
  Widget build(BuildContext context) {
    return CepInformationExpansionItem(
      label: 'Bairro',
      content: cep.bairro,
    );
  }
}
