import 'dart:async';

import 'package:flutter/material.dart';

import '../../../share/ds/ds_logo.dart';
import '../../components/adra_colors.dart';
import '../../mixins/mixins.dart';
import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({
    super.key,
    required this.presenter,
  });

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with NavigationManager {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    DSLogoType logoType;
    bool showLogo = false;
    bool showLoading = false;

    switch (_step) {
      case 1:
        backgroundColor = AdraColors.primary;
        logoType = DSLogoType.black;
        showLogo = true;
        break;
      case 2:
        backgroundColor = AdraColors.primary;
        logoType = DSLogoType.white;
        showLogo = true;
        showLoading = true;
        break;
      default:
        backgroundColor = AdraColors.white;
        logoType = DSLogoType.white;
        break;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          if (showLogo)
            Center(
              child: DSLogo(
                widht: 200,
                type: logoType,
              ),
            ),
          if (showLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 150.0),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AdraColors.white,
                    ),
                    strokeWidth: 6.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToListener);
    _startAnimation();
  }

  void _startAnimation() {
    Timer(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          setState(() {
            _step = 1;
          });
        }
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _step = 2;
            });
          }
          Timer(const Duration(seconds: 1), () {
            if (mounted) {
              widget.presenter.checkAccount();
            }
          });
        });
      },
    );
  }
}
