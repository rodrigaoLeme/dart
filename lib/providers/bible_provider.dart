import 'package:bibleplan/data/bible.dart';

enum BibleType { ara, rv, esv, lsg, cuv }

const List<String> _bibleNames = ["ARA", "RV", "ESV", "LSG", "CUVS"];

class BibleProvider {
  static BibleProvider instance = BibleProvider._();

  Bible? bible;
  BibleProvider._();

  Future<Bible?> openBible(BibleType name) async {
    return bible = await Bible.load(_bibleNames[name.index]);
  }
}
