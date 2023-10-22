import 'package:flutter/material.dart';
import 'package:flutter_desafio_via_cep/models/cep_model.dart';

import '../bairro_information.dart';
import '../cep_information.dart';
import '../complemento_information.dart';
import '../localidade_information.dart';
import '../logradouro_information.dart';
import '../uf_information.dart';

class CepInformationContent extends StatelessWidget {
  const CepInformationContent({super.key, required this.cep});

  final CepModel cep;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CepInformation(cep: cep),
        const SizedBox(
          height: 8,
        ),
        LogradouroInformation(cep: cep),
        const SizedBox(
          height: 8,
        ),
        BairroInformation(cep: cep),
        const SizedBox(
          height: 8,
        ),
        ComplementoInformation(cep: cep),
        const SizedBox(
          height: 8,
        ),
        LocalidadeInformation(cep: cep),
        const SizedBox(
          height: 8,
        ),
        UFInformation(cep: cep),
      ],
    );
  }
}
