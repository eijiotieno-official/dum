// Clean up a title string by removing content within parentheses, brackets, and file extensions
String formattedTitle(String title) {
  // Make a copy of the original title
  String cleanedTitle = title;

  // Remove content within parentheses
  cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\([^)]*\)'), '');

  // Remove content within brackets
  cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\[[^\]]*\]'), '');

  // Remove file extension (if present)
  if (cleanedTitle.contains('.')) {
    // Remove everything after the first '.'
    cleanedTitle = cleanedTitle.split('.').first;
  }

  // Return the cleaned-up title
  return cleanedTitle;
}
