import 'package:flutter/material.dart';

import '../../models/cep_model.dart';
import 'bairro_information.dart';
import 'complemento_information.dart';
import 'logradouro_information.dart';

class CepInformationExpansionTile extends StatelessWidget {
  const CepInformationExpansionTile({
    super.key,
    required this.cep,
    required this.onPressed,
  });

  final CepModel cep;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: _CepInformationBody(
        title: Text('${cep.localidade}/${cep.uf}'),
        subtitle: Text(
          cep.cep,
          style: const TextStyle(color: Colors.black54),
        ),
        leading: Icon(
          Icons.location_on,
          color: Colors.red[400],
        ),
        children: [
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
            height: 16,
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text('Ver detalhes'),
          )
        ],
      ),
    );
  }
}

class _CepInformationBody extends StatelessWidget {
  const _CepInformationBody({
    required this.title,
    this.subtitle,
    this.leading,
    this.children = const <Widget>[],
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      title: title,
      leading: leading,
      subtitle: subtitle,
      childrenPadding: const EdgeInsets.all(16.0),
      children: children,
    );
  }
}
