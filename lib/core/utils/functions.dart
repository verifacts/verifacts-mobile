


String? extractUrl(String text) {
    // Regex pattern to match URLs
    final urlPattern = RegExp(
      r'https?://[^\s]+|www\.[^\s]+',
      caseSensitive: false,
    );

    final match = urlPattern.firstMatch(text);
    return match?.group(0);
  }

  String removeUrl(String text) {
    // Remove URLs from text
    final urlPattern = RegExp(
      r'https?://[^\s]+|www\.[^\s]+',
      caseSensitive: false,
    );

    return text.replaceAll(urlPattern, '').trim();
  }
