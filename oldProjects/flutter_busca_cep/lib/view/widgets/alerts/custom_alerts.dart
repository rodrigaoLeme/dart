import 'package:flutter/material.dart';
import 'package:flutter_desafio_via_cep/models/cep_model.dart';
import 'package:flutter_desafio_via_cep/view/widgets/alerts/alert_title.dart';
import 'package:flutter_desafio_via_cep/view/widgets/alerts/cep_information_content.dart';
import 'package:flutter_desafio_via_cep/view/widgets/alerts/content_message.dart';

import 'close_button.dart';

AlertDialog successAlert(
    {String title = 'Localização Encontrada!',
    CepModel? cep,
    String message = 'Operação realizada com sucesso',
    required VoidCallback onCloseButtonPressed}) {
  return _customAlert(
    title: AlertTitle(
        prefixIcon: Icon(
          Icons.location_on,
          color: Colors.red[400],
        ),
        title: title),
    content: cep != null
        ? CepInformationContent(cep: cep)
        : ContentMessage(message: message),
    actions: [
      CustomCloseButton(
        onPressed: onCloseButtonPressed,
      ),
    ],
  );
}

AlertDialog cepNotFoundAlert(
    {required String message, required VoidCallback onCloseButtonPressed}) {
  return _customAlert(
      title: AlertTitle(
          prefixIcon: Icon(
            Icons.location_off,
            color: Colors.purple[400],
          ),
          title: 'Localização não encontrada'),
      content: ContentMessage(message: message),
      actions: [
        CustomCloseButton(
          onPressed: onCloseButtonPressed,
        ),
      ]);
}

AlertDialog errorAlert(
    {String title = 'Error',
    required String message,
    required VoidCallback onCloseButtonPressed}) {
  return _customAlert(
      title: AlertTitle(
          prefixIcon: const Icon(
            Icons.error,
            color: Colors.blue,
          ),
          title: title),
      content: ContentMessage(message: message),
      actions: [
        CustomCloseButton(
          onPressed: onCloseButtonPressed,
        ),
      ]);
}

AlertDialog _customAlert(
    {required Widget title,
    required Widget content,
    required List<Widget> actions}) {
  return AlertDialog(
    title: title,
    titlePadding: const EdgeInsets.all(18),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
    content: content,
    actions: actions,
  );
}
