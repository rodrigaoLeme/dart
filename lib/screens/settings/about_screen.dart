import 'package:bibleplan/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Widget _boldTitle(String title, String content) =>
      Row(children: <Widget>[Txt.b(title), Txt(content)]);
  Widget _boldTitleCol(String title, String content) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Txt.b(title),
        const SizedBox(width: 10),
        Txt(content)
      ]);

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const VSpacer(16),
        Txt.s(localize('about_title'), 18, weight: FontWeight.bold),
        const VSpacer(30),
        Txt.headline5(localize('about_subtitle'), color: AppStyle.primaryColor),
        const VSpacer(10),
        const Txt(
            "Av. L3 Sul, SGAS, Quadra 611\nConjunto D, Parte C, Asa Sul\nCEP: 70200-710\nBrasília, DF – Brasil\n(61) 3701-1818"),
        const VSpacer(10),
        _boldTitle(localize('about_president'), "Pr. Stanley Arco"),
        const VSpacer(10),
        _boldTitle(localize('about_secretary'), "Pr. Edward Heindinger"),
        const VSpacer(10),
        _boldTitle(localize('about_treasurer'), "Pr. Edson Medeiros"),
        const VSpacer(50),
        Txt.headline5(localize('about_cpegwTitle'),
            color: AppStyle.primaryColor),
        const VSpacer(10),
        const Txt(
            "Estrada Municipal Pr. Walter Boger, Km 3,5\nLagoa Bonita - CEP: 13448-900\nEngenheiro Coelho, SP - Brasil\n(19) 3858-9033\ncentro.white@unasp.edu.br",
            size: 16),
        const VSpacer(30),
        _boldTitleCol(localize('about_generalDirectorate'),
            "Pr. Hélio Carnassale (DSA) - v. 1.0\nPr. Adolfo Suárez (DSA) - v. 2.0"),
        const VSpacer(10),
        _boldTitleCol(localize('about_executiveDirectorate'),
            "Pr. Renato Stencel (Centro White)"),
        const VSpacer(10),
        _boldTitleCol(localize('about_technicalAssistant'),
            "Pr. Julio Cesar Ribeiro (Centro White)"),
        const VSpacer(10),
        _boldTitleCol(
            localize('about_reviewOfVerses'), "Vinicius Petersen Brandão"),
        const VSpacer(50),
        Txt.headline5(localize('about_development'),
            color: AppStyle.primaryColor),
        const VSpacer(10),
        const Txt("IATec - Instituto Adventista de Tecnologia"),
        const SafeArea(child: VSpacer(30))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("about").toUpperCase()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.defaultMargin),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
          child: SingleChildScrollView(
            child: body(),
          ),
        ),
      ),
    );
  }
}
