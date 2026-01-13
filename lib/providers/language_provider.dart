import 'package:bibleplan/shared/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  static Language instance = Language._();

  String _current = "en";
  String get current => _current;

  Language._();

  Future init() async {
    var sp = await SharedPreferences.getInstance();
    var lan = sp.getString("APP_LANGUAGE");
    _current = lan ?? "en";
  }

  Future setLanguage(String language) async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("APP_LANGUAGE", language);
    _current = language;
  }

  static final Map<String, List<String>> _daysOfWeekShortMap = {
    "pt": WEEK_DAYS_ABBR,
    "es": WEEK_DAYS_ABBR_ES,
    "en": WEEK_DAYS_ABBR_EN,
    "fr": WEEK_DAYS_ABBR_FR,
    "zh-CN": WEEK_DAYS_ABBR_ZH_CN,
  };

  static final Map<String, List<String>> _daysOfWeekMap = {
    "pt": WEEK_DAYS,
    "es": WEEK_DAYS_ES,
    "en": WEEK_DAYS_EN,
    "fr": WEEK_DAYS_FR,
    "zh-CN": WEEK_DAYS_ZH_CN,
  };

  static final Map<String, List<String>> _monthsMap = {
    "pt": MONTHS_PT,
    "es": MONTHS_ES,
    "en": MONTHS_EN,
    "fr": MONTHS_FR,
    "zh-CN": MONTHS_ZH_CN,
  };

  static final Map<String, List<String>> _monthsShortMap = {
    "pt": MONTHS_ABRV,
    "es": MONTHS_ABRV_ES,
    "en": MONTHS_ABRV_EN,
    "fr": MONTHS_ABRV_FR,
    "zh-CN": MONTHS_ABRV_ZH_CN,
  };

  static List<String> get daysOfWeekShort =>
      _daysOfWeekShortMap[instance.current] ?? WEEK_DAYS_ABBR_EN;

  static List<String> get daysOfWeek =>
      _daysOfWeekMap[instance.current] ?? WEEK_DAYS_EN;

  static List<String> get months => _monthsMap[instance.current] ?? MONTHS_EN;

  static List<String> get monthsShort =>
      _monthsShortMap[instance.current] ?? MONTHS_ABRV_EN;
}
