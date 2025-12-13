String? extractUrl(String text) {
  // Regex pattern to match URLs including those with fragments and query params
  // This pattern matches http/https URLs and stops at whitespace or quotes
  final urlPattern = RegExp(r'https?://[^\s"]+', caseSensitive: false);

  final match = urlPattern.firstMatch(text);
  if (match == null) return null;

  String url = match.group(0)!;

  // Clean up trailing punctuation that's not part of the URL
  // Remove trailing periods, commas, etc. that might be sentence punctuation
  url = url.replaceAll(RegExp(r'[.,;!?]+$'), '');

  return url;
}

String removeUrl(String text) {
  // Remove URLs from text including surrounding quotes
  final urlPattern = RegExp(
    r'["\"]?https?://[^\s"]+["\"]?',
    caseSensitive: false,
  );

  String cleaned = text.replaceAll(urlPattern, '');

  // Clean up extra whitespace and quotes
  cleaned = cleaned.replaceAll(
    RegExp(r'\s+'),
    ' ',
  ); // Multiple spaces to single
  cleaned = cleaned.replaceAll(RegExp(r'["\"]'), ''); // Remove stray quotes
  cleaned = cleaned.trim();

  return cleaned;
}
