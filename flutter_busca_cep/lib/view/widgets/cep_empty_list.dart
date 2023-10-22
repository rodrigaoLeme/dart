import 'package:flutter/material.dart';

class CepEmptyList extends StatelessWidget {
  const CepEmptyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _EmptyMessageTitle(),
        _EmptyMessageContent(),
      ],
    );
  }
}

class _EmptyMessageContent extends StatelessWidget {
  const _EmptyMessageContent();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Pesquise um CEP',
      style: _style(context),
    );
  }

  TextStyle _style(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}

class _EmptyMessageTitle extends StatelessWidget {
  const _EmptyMessageTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Nenhum CEP Cadastrado',
      style: _style(context),
    );
  }

  TextStyle _style(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
