import 'package:flutter/material.dart';
import 'package:flutter_desafio_via_cep/controllers/cep_controller.dart';
import 'package:flutter_desafio_via_cep/models/cep_model.dart';

import 'package:flutter_desafio_via_cep/view/widgets/form_label.dart';

import '../widgets/alerts/custom_alerts.dart';
import '../widgets/outlined_text_form_field.dart';

class CepDetailsPage extends StatefulWidget {
  final CepModel cep;
  final CepController cepController;
  const CepDetailsPage(
      {super.key, required this.cep, required this.cepController});

  @override
  State<CepDetailsPage> createState() => _CepDetailsPageState();
}

class _CepDetailsPageState extends State<CepDetailsPage> {
  //final CepController cepController = CepController();
  late TextEditingController cepFieldController;
  late TextEditingController logradouroFieldController;
  late TextEditingController bairroFieldController;
  late TextEditingController complementoFieldController;
  late TextEditingController localidadeFieldController;
  late TextEditingController ufFieldController;

  @override
  void initState() {
    super.initState();

    cepFieldController = TextEditingController(text: widget.cep.cep);
    logradouroFieldController =
        TextEditingController(text: widget.cep.logradouro);
    bairroFieldController = TextEditingController(text: widget.cep.bairro);
    complementoFieldController =
        TextEditingController(text: widget.cep.complemento);
    localidadeFieldController =
        TextEditingController(text: widget.cep.localidade);
    ufFieldController = TextEditingController(text: widget.cep.uf);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.cepController,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalhes do CEP'),
              actions: [
                IconButton(
                    onPressed: _onEditPressed, icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: _onRemovePressed,
                    icon: const Icon(Icons.delete)),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel(label: 'CEP'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: cepFieldController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FormLabel(label: 'Logradouro'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: logradouroFieldController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FormLabel(label: 'Bairro'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: bairroFieldController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FormLabel(label: 'Complemento'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: complementoFieldController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FormLabel(label: 'Localidade'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: localidadeFieldController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const FormLabel(label: 'UF'),
                  const SizedBox(
                    height: 8,
                  ),
                  OutlinedTextFormField(
                    controller: ufFieldController,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _onRemovePressed() async {
    await widget.cepController.remove(widget.cep);
    await widget.cepController.getAll();

    if (widget.cepController.error) {
      await _showMessageError(widget.cepController.errorMessage!);
    } else {
      await _showDeleteSuccessMessage();
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDeleteSuccessMessage() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return successAlert(
          title: 'Localização Excluída!',
          message: 'CEP excluído com sucesso!',
          onCloseButtonPressed: () async {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Future<void> _onEditPressed() async {
    final cepToUpdate = widget.cep.copyWith(
        cep: cepFieldController.text,
        logradouro: logradouroFieldController.text,
        bairro: bairroFieldController.text,
        complemento: complementoFieldController.text,
        localidade: localidadeFieldController.text,
        uf: ufFieldController.text);

    await widget.cepController.update(cepToUpdate);
    await widget.cepController.getAll();

    if (widget.cepController.error) {
      await _showMessageError(widget.cepController.errorMessage!);
    } else {
      await _showCepInformations(cepToUpdate);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showCepInformations(CepModel cep) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return successAlert(
          title: 'Localização Atualizada!',
          cep: cep,
          onCloseButtonPressed: () async {
            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Future<void> _showMessageError(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return errorAlert(
            message: message,
            onCloseButtonPressed: () {
              Navigator.pop(context);
            });
      },
    );
  }
}
