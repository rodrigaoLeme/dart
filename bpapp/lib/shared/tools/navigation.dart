//import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/common.dart';
//import 'package:flutter/material.dart';

Future<T?> pushScreen<T>(BuildContext context, Widget screen,
        {bool fullscreenDialog = false, bool root = false}) =>
    Navigator.of(context, rootNavigator: root).push<T>(MaterialPageRoute(
        builder: (context) => screen, fullscreenDialog: fullscreenDialog));

Future<T?> pushReplacementScreen<T, TO>(BuildContext context, Widget screen,
        {bool fullscreenDialog = false, TO? result}) =>
    Navigator.of(context).pushReplacement<T, TO>(
        MaterialPageRoute(
            builder: (context) => screen, fullscreenDialog: fullscreenDialog),
        result: result);

void popScreen<T>(BuildContext context, {T? result, bool useRoot = false}) =>
    Navigator.of(context, rootNavigator: useRoot).pop<T>(result);

Future<T?> showBottomWidget<T>(
    {required BuildContext context,
    required Widget child,
    bool isScrollControlled = false}) {
  return showModalBottomSheet<T>(
    backgroundColor: Colors.transparent,
    barrierColor: Colors.grey.withAlpha(100),
    useRootNavigator: true,
    context: context,
    isScrollControlled: isScrollControlled,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: AppStyle.backgroundColor,
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [child],
            ),
          ),
        ),
      );
    },
  );
}
