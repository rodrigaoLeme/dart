import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/providers/language_provider.dart';

class EGWBooksProvider {
  static EGWBooksProvider instance = EGWBooksProvider._();
  final Map<String, Map<String, String>> _booksName = {
    "pt": {
      "PP": "Patriarcas e Profetas",
      "DTN": "Desejado de Todas as Nações",
      "PR": "Profetas e Reis",
      "GC": "Grande Conflito",
      "AA": "Atos dos Apóstolos",
      "PJ": "Parábolas de Jesus"
    },
    "es": {
      "PP": "Historia de los Patriarcas y Profetas",
      "DTN": "El Deseado de Todas las Gentes",
      "PR": "Profetas y Reyes",
      "GC": "El Conflicto de los Siglos",
      "AA": "Los Hechos de los Apóstoles",
      "PJ": "Palabras de Vida del Gran Maestro"
    },
    "en": {
      "PP": "Patriarchs and Prophets",
      "DTN": "The Desire of Ages",
      "PR": "Prophets and Kings",
      "GC": "The Great Controversy",
      "AA": "The Acts of the Apostles",
      "PJ": "Christ's Object Lessons"
    },
    "fr": {
      "PP": "Patriarches et Prophètes",
      "DTN": "Jésus-Christ",
      "PR": "Prophètes et Rois",
      "GC": "La Tragédie des Siècles",
      "AA": "Conquérants Pacifiques",
      "PJ": "Les Paraboles de Jésus"
    },
    "zh-CN": {
      "PP": "先祖与先知",
      "DTN": "历代愿望",
      "PR": "先知与君王",
      "GC": "善恶之争",
      "AA": "使徒行述",
      "PJ": "基督比喻实训"
    }
  };

  final Map<String, Map<String, String>> _booksLanguageToPT = {
    "pt": {
      "PP": "PP",
      "DTN": "DTN",
      "PR": "PR",
      "GC": "GC",
      "AA": "AA",
      "PJ": "PJ"
    },
    "es": {
      "PP": "PP",
      "DTG": "DTN",
      "PR": "PR",
      "CS": "GC",
      "HAP": "AA",
      "PVGM": "PJ",
    },
    "en": {
      "PP": "PP",
      "DA": "DTN",
      "PK": "PR",
      "GC": "GC",
      "AA": "AA",
      "COL": "PJ",
    },
    "fr": {
      "PP": "PP",
      "JC": "DTN",
      "PR": "PR",
      "TS": "GC",
      "CP": "AA",
      "PJ": "PJ",
    },
    "zh-CN": {
      "先祖": "PP",
      "历代": "DTN",
      "先知": "PR",
      "善恶": "GC",
      "使徒": "AA",
      "基督": "PJ",
    }
  };

  Map<String, Book?> _books = <String, Book?>{};

  EGWBooksProvider._();

  Future<Book?> getBook(String book) async {
    if (!_books.containsKey(book)) {
      _books[book] = await Book.load(book, Language.instance.current);
    }
    return _books[book];
  }

  String? bookName(String? code) =>
      _booksName[Language.instance.current]![code];

  String bookCode(Book book) =>
      _booksLanguageToPT[Language.instance.current]![book.shortName]!;

  List<String> codes() =>
      (_booksName[Language.instance.current]!.keys).toList();

  void reset() {
    _books = <String, Book?>{};
  }
}
