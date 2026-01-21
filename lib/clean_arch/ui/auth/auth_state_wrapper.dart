import 'package:flutter/material.dart';

import '../../presentation/auth/auth.dart';
import './login_screen.dart';

class AuthStateWrapper extends StatefulWidget {
  final Widget homeScreen;

  const AuthStateWrapper({super.key, required this.homeScreen});

  @override
  State<AuthStateWrapper> createState() => _AuthStateWrapperState();
}

class _AuthStateWrapperState extends State<AuthStateWrapper> {
  late final AuthPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = AuthPresenter();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUIState>(
        stream: _presenter.state,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _presenter.currentState;

          if (state.status == AuthUIStatus.initial) {
            return const Scaffold(
              backgroundColor: Color(0xFF0B7FA4),
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }

          if (state.isAuthenticated) {
            return widget.homeScreen;
          }

          return const LoginScreen();
        });
  }
}
