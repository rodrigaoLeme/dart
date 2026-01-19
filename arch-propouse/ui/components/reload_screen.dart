import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class ReloadScreen extends StatelessWidget {
  final String error;
  final Future<void> Function() reload;

  const ReloadScreen({super.key, required this.error, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0),
            child: Text(
              R.string.anErrorHasOccurred,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24),
            child: Text(
              R.string.youAreOffline,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 6.0),
            child: Text(
              R.string.checkInternetAccess,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(child: Container()),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(340, 48),
                  backgroundColor: Theme.of(context).primaryColorDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0))),
              onPressed: reload,
              child: Text(
                R.string.reload,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  R.string.sendFeedback,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
