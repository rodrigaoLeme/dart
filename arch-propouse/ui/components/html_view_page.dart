import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../share/utils/app_color.dart';
import '../helpers/helpers.dart';
import 'components.dart';

class HtmlViewPage extends StatelessWidget {
  final String html;
  final String? title;
  final bool isTitleInBody;
  final bool showAppBar;

  const HtmlViewPage({
    super.key,
    required this.html,
    this.title,
    this.isTitleInBody = false,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? AppBar(
              elevation: 0,
              backgroundColor: AdraColors.primary,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.translucent,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
              title: Align(
                alignment: Alignment.topLeft,
                child: AdraText(
                  text: '',
                  textStyleEnum: AdraTextStyleEnum.semibold,
                  textSize: AdraTextSizeEnum.h3w5,
                  color: AdraColors.white,
                  adraStyles: AdraStyles.poppins,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isTitleInBody && title != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AdraText(
                    text: title!,
                    textSize: AdraTextSizeEnum.h2,
                    textStyleEnum: AdraTextStyleEnum.bold,
                    color: AdraColors.black,
                    textAlign: TextAlign.start,
                    adraStyles: AdraStyles.poppins,
                  ),
                ),
              CustomHtml(
                htmlData: '<h1>$title</h1>$html',
                onLinkClick: _handleLinkClick,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLinkClick() {
    _launchURL('https://privacy.adventist.org/');
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CustomHtml extends StatelessWidget {
  final String htmlData;
  final void Function()? onLinkClick;

  const CustomHtml({super.key, required this.htmlData, this.onLinkClick});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlData,
      onLinkTap: (String? url, Map<String, String> attributes, element) {
        if (url == 'https://privacy.adventist.org/') {
          if (onLinkClick != null) {
            onLinkClick!();
          }
        } else if (url != null) {
          _launchURL(url);
        }
      },
      style: {
        'img': Style(
          width: Width(
            ResponsiveLayout.of(context).wp(80),
            Unit.px,
          ),
          height: Height(5, Unit.rem),
        ),
      },
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
