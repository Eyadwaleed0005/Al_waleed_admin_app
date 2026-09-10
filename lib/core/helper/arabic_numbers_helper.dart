String toArabicNumbers(
  num number, {
  int decimalPlaces = 1,
}) {
  const String westernNumbers = '0123456789';
  const String arabicNumbers = '٠١٢٣٤٥٦٧٨٩';

  final bool isWholeNumber = number.toDouble() == number.roundToDouble();

  final String formattedNumber = isWholeNumber
      ? number.toInt().toString()
      : number.toStringAsFixed(decimalPlaces);

  return formattedNumber.split('').map((character) {
    final int numberIndex = westernNumbers.indexOf(character);

    if (numberIndex == -1) {
      return character;
    }

    return arabicNumbers[numberIndex];
  }).join();
}