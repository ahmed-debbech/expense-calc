bool isFloat(String text) {
  for (int i = 0; i <= text.length - 1; i++) {
    if (((text.codeUnitAt(i) > 57) || (text.codeUnitAt(i) < 48)) &&
        (text[i] != '.')) {
      return false;
    }
  }
  return true;
}
