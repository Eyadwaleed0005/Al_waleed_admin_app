String toArabicNumbers(num number) {
  const westernNumbers = '0123456789';
  const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';

  return number.toString().split('').map((character) {
    final index = westernNumbers.indexOf(character);

    if (index == -1) {
      return character;
    }

    return arabicNumbers[index];
  }).join();
}