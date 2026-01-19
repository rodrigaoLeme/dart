import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

void showSuccessMessage(BuildContext context, String success) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 9),
    backgroundColor: Theme.of(context).canvasColor,
    content: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0),
            child: Icon(
              Icons.done,
              size: 20,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(
              R.string.successTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 24),
            child: Text(
              success,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}
