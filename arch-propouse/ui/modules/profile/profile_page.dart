import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/adra_button.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import 'profile_presenter.dart';

class ProfilePage extends StatefulWidget {
  final ProfilePresenter presenter;

  const ProfilePage({
    super.key,
    required this.presenter,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with NavigationManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToListener);
    widget.presenter.loadProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdraColors.white,
      appBar: AppBar(
        backgroundColor: AdraColors.primary,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: AdraText(
              text: R.string.profile,
              textSize: AdraTextSizeEnum.h3w5,
              textStyleEnum: AdraTextStyleEnum.regular,
              color: AdraColors.white,
              adraStyles: AdraStyles.poppins,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(
            Icons.arrow_back,
            color: AdraColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: StreamBuilder(
            stream: widget.presenter.profileViewModel,
            builder: (context, snapshot) {
              final profile = snapshot.data;
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FutureBuilder(
                          future: widget.presenter.getLoggedUser(),
                          builder: (context, snapshot) {
                            if (snapshot.data?.photoUrl == null) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Center(
                                child: ClipOval(
                                  child: Image.network(
                                    snapshot.data?.photoUrl ?? '',
                                    fit: BoxFit.cover,
                                    width: 104.0,
                                    height: 104.0,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AdraText(
                            text: snapshot.data?.name ?? '',
                            textSize: AdraTextSizeEnum.h2,
                            textStyleEnum: AdraTextStyleEnum.bold,
                            color: AdraColors.black,
                            adraStyles: AdraStyles.poppins,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
                    child: AdraButton(
                      onPressed: () {
                        widget.presenter.logoff();
                      },
                      title: R.string.logout,
                      buttonColor: AdraColors.splashColor,
                      borderRadius: 50.0,
                      buttonHeigth: 52.0,
                      titleColor: AdraColors.primary,
                      prefixIcon: SvgPicture.asset(
                        'lib/ui/assets/images/icon/arrow-left.svg',
                      ),
                    ),
                  ),
                  AdraText(
                    text: profile?.version ?? '',
                    textSize: AdraTextSizeEnum.subheadline,
                    textStyleEnum: AdraTextStyleEnum.regular,
                    color: AdraColors.secundary,
                    adraStyles: AdraStyles.poppins,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
