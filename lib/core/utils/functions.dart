String? extractUrl(String text) {
  RegExp urlPattern = RegExp(r'https?://[^\s"]+', caseSensitive: false);

  RegExpMatch? match = urlPattern.firstMatch(text);
  if (match == null) return null;

  String url = match.group(0)!;

  int textFragmentIndex = url.indexOf('#:~:text=');
  if (textFragmentIndex != -1) {
    url = url.substring(0, textFragmentIndex);
  }

  url = url.replaceAll(RegExp(r'[.,;!?]+$'), '');

  return url;
}

String removeUrl(String text) {
  RegExp urlPattern = RegExp(
    r'["\"]?https?://[^\s"]+["\"]?',
    caseSensitive: false,
  );

  String cleaned = text.replaceAll(urlPattern, '');

  cleaned = cleaned.replaceAll(
    RegExp(r'\s+'),
    ' ',
  );
  cleaned = cleaned.replaceAll(RegExp(r'["\"]'), '');
  cleaned = cleaned.trim();

  return cleaned;
}
