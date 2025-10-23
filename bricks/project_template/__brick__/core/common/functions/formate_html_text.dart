String cleanHtmlText(String htmlText) {
  if (htmlText.isEmpty) return '';

  // Remove common HTML tags and entities
  String cleanedText = htmlText
      .replaceAll(RegExp(r'<[^>]*>'), '') // Remove all HTML tags
      .replaceAll('&nbsp;', ' ') // Replace &nbsp; with space
      .replaceAll('&amp;', '&') // Replace &amp; with &
      .replaceAll('&lt;', '<') // Replace &lt; with <
      .replaceAll('&gt;', '>') // Replace &gt; with >
      .replaceAll('&quot;', '"') // Replace &quot; with "
      .replaceAll('&#39;', "'") // Replace &#39; with '
      .replaceAll('&apos;', "'") // Replace &apos; with '
      .replaceAll(
        RegExp(r'\s+'),
        ' ',
      ) // Replace multiple spaces with single space
      .trim(); // Remove leading/trailing spaces

  return cleanedText;
}

String formatTextAsBulletPoints(String text) {
  if (text.isEmpty) return '';

  // Clean the HTML first
  String cleanText = cleanHtmlText(text);

  // Split by common sentence endings and filter out empty strings
  List<String> sentences = cleanText
      .split(RegExp(r'[.!?]+'))
      .map((sentence) => sentence.trim())
      .where((sentence) => sentence.isNotEmpty)
      .toList();

  // If no sentences found, split by commas or other separators
  if (sentences.isEmpty) {
    sentences = cleanText
        .split(RegExp(r'[,;]+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();
  }

  // If still no sentences, split by new lines
  if (sentences.isEmpty) {
    sentences = cleanText
        .split('\n')
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();
  }

  // If still empty, return the original cleaned text
  if (sentences.isEmpty) {
    return cleanText;
  }

  // Format as bullet points
  return sentences.map((sentence) => '• $sentence').join('\n');
}
