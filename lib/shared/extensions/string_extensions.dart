// ignore: camel_case_extensions
extension bible on String {
  String substringToWord(int length) {
    if (length >= this.length) return this;

    int finalLength = length;
    while (this[finalLength] != " " && finalLength > 0) {
      finalLength--;
    }
    if (finalLength > 0) {
      return substring(0, finalLength > 0 ? finalLength : length) + "...";
    }
    return substring(0, length);
  }
}
