import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/clean_arch/ui/auth/auth.dart';
import 'package:bibleplan/screens/home/homescreen.dart';
import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

import 'package:bibleplan/shared/localize.dart';

import '../../presentation/profile/profile.dart';
import '../helpers/platform_helper.dart';
import './widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfilePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = ProfilePresenter();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  // Métodos de feedback

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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Modais

  void _showBenefitsModal() {
    showDialog(
      context: context,
      barrierColor: Colors.grey.withAlpha(100),
      builder: (context) => AlertDialog(
        backgroundColor: AppStyle.backgroundColor,
        title: Txt.b(localize('anonymousBenefitsTitle')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBenefitItem(
                Icons.cloud_upload,
                localize('anonymousBackupTitle'),
                localize('anonymousBackupDescription'),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBenefitItem(
                Icons.devices,
                localize('anonymousMultiplesDevicesTitle'),
                localize('anonymousMultipleDevicesDescription'),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBenefitItem(
                Icons.security,
                localize('anonymousSecurityTitle'),
                localize('anonymousSecurityDescription'),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBenefitItem(
                Icons.sync,
                localize('anonymousSyncTitle'),
                localize('anonymousSyncDescription'),
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBenefitItem(
                Icons.money_off_csred,
                localize('anonymousTaxTitle'),
                localize('anonymousTaxDescription'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Txt(localize('anonymousFinishButton')),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF007AA7),
          size: 32,
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.grey.withAlpha(100),
      builder: (context) => AlertDialog(
        backgroundColor: AppStyle.backgroundColor,
        title: Txt.b(localize('logoutTitle')),
        content: Txt(localize('logoutMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localize('logoutConfirmNegative')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(localize('logoutConfirmPositive')),
          )
        ],
      ),
    );

    if (confirm == true) {
      await _presenter.signOut();

      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => AuthStateWrapper(
                key: UniqueKey(),
                homeScreen: const HomeScreen(),
              ),
            ),
            (route) => false);
      }
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.grey.withAlpha(100),
      builder: (context) => AlertDialog(
        backgroundColor: AppStyle.backgroundColor,
        title: Txt.b(localize('authenticatedDeleteAccountTitle')),
        content: Txt(localize('authenticatedDeleteAccountMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Txt(localize('authenticatedDeleteAccountNegativeButton')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Txt(localize('authenticatedDeleteAccountPositiveButton')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _presenter.deleteAccount();

      if (mounted) {
        // AuhtStateWrapper redireciona sozinho
        Navigator.of(context).pop();
      }

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => AuthStateWrapper(
                key: UniqueKey(),
                homeScreen: const HomeScreen(),
              ),
            ),
            (route) => false);
      }
    }
  }

  Widget _buildAnonymousContent(state) {
    return Column(
      children: [
        Txt.b(
          localize('anonymousUser'),
          size: 24,
          color: AppStyle.primaryColor,
        ),
        const SizedBox(
          height: 24,
        ),
        AnonymousInfoCard(onLearnMore: _showBenefitsModal),
        const SizedBox(
          height: 24,
        ),
        Txt(
          localize('anonymousLinkedAccount'),
          size: 18,
          weight: FontWeight.w800,
        ),
        const SizedBox(
          height: 16,
        ),
        if (PlatformHelper.isAppleSignInAvailable) ...[
          LinkAccountButton(
            provider: 'apple',
            onPressed: () async {
              await _presenter.linkWithApple();
              if (_presenter.currentState.isLoaded &&
                  !_presenter.currentState.user!.isAnonymous) {
                _showSuccess(localize('anonymousLinkedSuccessMessage'));
              }
            },
            isLoading: state.isProviderLinking('apple'),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
        LinkAccountButton(
          provider: 'google',
          onPressed: () async {
            await _presenter.linkWithGoogle();
            if (_presenter.currentState.isLoaded &&
                !_presenter.currentState.user!.isAnonymous) {
              _showSuccess(localize('anonymousLinkedSuccessMessage'));
            }
          },
          isLoading: state.isProviderLinking('google'),
        ),
      ],
    );
  }

  Widget _buildAuthenticatedContent(user) {
    return ProfileInfoCard(user: user);
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        icon: const Icon(
          Icons.logout,
          size: 30,
        ),
        label: Txt(
          localize('logoutButton'),
          size: 18,
        ),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          foregroundColor: AppStyle.primaryColor,
          side: BorderSide(
            color: AppStyle.primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(state) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: state.isDeleting ? null : _confirmDeleteAccount,
        icon: state.isDeleting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : const Icon(
                Icons.delete,
                size: 30,
                color: Colors.red,
              ),
        label: Txt.b(
          localize('authenticatedDeleteAccountButton'),
          size: 18,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize('profileTitle').toUpperCase()),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _presenter.state,
        builder: (context, snapshot) {
          final state = snapshot.data ?? _presenter.currentState;

          if (state.hasError && state.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showError(state.errorMessage!);
            });
          }

          if (state.isLoading && state.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Txt.b('Erro ao carregar perfil'),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _presenter.loadUser,
                    child: const Txt('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          final user = state.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ProfileAvatar(
                  photoUrl: user.photoUrl,
                  displayName: user.displayName,
                  size: 120,
                ),
                if (user.isAnonymous)
                  _buildAnonymousContent(state)
                else
                  _buildAuthenticatedContent(user),
                const SizedBox(
                  height: 24,
                ),
                _buildLogoutButton(),
                if (!user.isAnonymous) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  _buildDeleteAccountButton(state),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
