extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension StringLowerCasingExtension on String {
  String lowercize() {
    if (isEmpty) return this;
    return this[0].toLowerCase() + substring(1);
  }
}
