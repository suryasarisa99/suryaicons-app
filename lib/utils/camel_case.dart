String toCamelCase(String input, {bool capitalizeFirst = false}) {
  final words = input.split('-');
  final capitalizedWords = words
      .sublist(1)
      .map((word) => word[0].toUpperCase() + word.substring(1));
  return [
    capitalizeFirst
        ? words[0][0].toUpperCase() + words[0].substring(1)
        : words[0],
    ...capitalizedWords,
  ].join();
}
