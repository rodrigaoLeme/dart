import 'package:flutter/material.dart';

import '../../controllers/cep_controller.dart';
import '../../models/cep_model.dart';
import '../widgets/alerts/custom_alerts.dart';
import '../widgets/cep_empty_list.dart';
import '../widgets/cep_information_expansion_tile.dart';
import '../widgets/cep_loading_indicator.dart';
import '../widgets/search_cep_bar.dart';
import 'cep_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = CepController();
  TextEditingController cepFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    await controller.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomePageBody(
        slivers: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return SliverToBoxAdapter(
                child: SearchCepBar(
                  controller: cepFieldController,
                  onSearchButtonPressed: _onSearchButtonPressed,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: _HeightSpacer(),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: cepInformationBuilder,
          ),
        ],
      ),
    );
  }

  Widget cepInformationBuilder(context, child) {
    final ceps = controller.ceps;

    if (controller.loading) {
      return const SliverToBoxAdapter(
        child: CepLoadingIndicator(),
      );
    } else if (controller.ceps.isEmpty) {
      return const SliverToBoxAdapter(
        child: CepEmptyList(),
      );
    } else {
      return SliverList.builder(
        itemCount: ceps.length,
        itemBuilder: (context, index) {
          final cep = ceps[index];
          return CepInformationExpansionTile(
            cep: cep,
            onPressed: () async => _goToDetailsPage(cep),
          );
        },
      );
    }
  }

  Future<void> _goToDetailsPage(CepModel cep) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CepDetailsPage(
          cep: cep,
          cepController: controller,
        ),
      ),
    );
  }

  Future<void> _onSearchButtonPressed() async {
    await controller.searchCep(cepFieldController.text);
    final cep = controller.cepModel;

    cepFieldController.clear();
    if (mounted) {
      if (controller.error) {
        await _showNotFoundError(controller.errorMessage!);
      } else {
        await _showCepInformations(cep);
      }
    }
  }

  Future<void> _showCepInformations(CepModel cep) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return successAlert(
          cep: cep,
          onCloseButtonPressed: () async {
            await controller.getAll();

            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Future<void> _showNotFoundError(String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return cepNotFoundAlert(
            message: message,
            onCloseButtonPressed: () {
              controller.clearErrorFields();

              Navigator.pop(context);
            });
      },
    );
  }
}

class _HeightSpacer extends StatelessWidget {
  const _HeightSpacer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody({this.slivers = const <Widget>[]});

  final List<Widget> slivers;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomScrollView(
          slivers: slivers,
        ),
      ),
    );
  }
}
