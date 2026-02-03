import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:bibleplan/shared/localize.dart';

import '../../presentation/auth/auth.dart';
import '../helpers/platform_helper.dart';
import './widgets/widgets.dart';

/// Tela de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Txt.b(
          message,
          size: 18,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _presenter.clearError();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<AuthUIState>(
          stream: _presenter.state,
          builder: (context, snapshot) {
            final state = snapshot.data ?? _presenter.currentState;

            if (state.hasError && state.errorMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showError(state.errorMessage!);
              });
            }

            return Stack(
              children: [
                Positioned(
                  top: size.height * 0.139,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/icon.png',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.4,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF007AA7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              localize('loginTitle'),
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily:
                                    GoogleFonts.merriweather().fontFamily,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              localize('loginDescription'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            if (PlatformHelper.isAppleSignInAvailable) ...[
                              AppleSignInButton(
                                textButton: localize('loginApple'),
                                onPressed: _presenter.signInWithApple,
                                isLoading: state.isProviderLoading('apple'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                            GoogleSignInButton(
                              textButton: localize('loginGoogle'),
                              onPressed: _presenter.signInWithGoogle,
                              isLoading: state.isProviderLoading('google'),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            AnonymousSignInButton(
                              textButton: localize('loginAnonymous'),
                              onPressed: _presenter.signInAnonymously,
                              isLoading: state.isProviderLoading('anonymous'),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
