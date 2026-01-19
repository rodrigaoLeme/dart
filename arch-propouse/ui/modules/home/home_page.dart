import 'package:flutter/material.dart';

import '../../../presentation/presenters/resources/resources_view_model.dart';
import '../../components/components.dart';
import 'home_presenter.dart';

class HomePage extends StatefulWidget {
  final HomePresenter presenter;
  const HomePage({
    super.key,
    required this.presenter,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.presenter.fetchResources();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      body: StreamBuilder<ResourcesViewModel?>(
        stream: widget.presenter.resourcesViewModel,
        builder: (context, snapshot) {
          final resourcesViewModel = snapshot.data;
          if (resourcesViewModel == null) {
            return Container(
              color: Colors.red,
            );
          }
          return ListView.builder(itemBuilder: (context, index) {
            final resourceViewModel = resourcesViewModel.data?[index];
            return SizedBox(
              height: 100,
              child: Text(resourceViewModel?.resource ?? ''),
            );
          });
        },
      ),
    );
  }
}
