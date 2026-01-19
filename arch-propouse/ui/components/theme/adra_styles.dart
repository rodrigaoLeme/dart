enum AdraStyles {
  poppins,
}

class TypographyHelper {
  static String getFontFamily(AdraStyles typography) {
    switch (typography) {
      case AdraStyles.poppins:
        return 'Poppins';
    }
  }
}
