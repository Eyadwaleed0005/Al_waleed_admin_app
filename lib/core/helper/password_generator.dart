import 'dart:math';

abstract final class PasswordGenerator {
  const PasswordGenerator._();

  static const String _upperCaseLetters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';

  static const String _lowerCaseLetters = 'abcdefghijkmnopqrstuvwxyz';

  static const String _numbers = '23456789';

  static const String _specialCharacters = r'!@#$%^&*';

  static final Random _random = Random.secure();

  static String generate({int length = 12}) {
    if (length < 8) {
      throw ArgumentError.value(
        length,
        'length',
        'Password length must be at least 8',
      );
    }

    final allCharacters =
        _upperCaseLetters + _lowerCaseLetters + _numbers + _specialCharacters;

    final passwordCharacters = <String>[
      _randomCharacter(_upperCaseLetters),
      _randomCharacter(_lowerCaseLetters),
      _randomCharacter(_numbers),
      _randomCharacter(_specialCharacters),
    ];

    while (passwordCharacters.length < length) {
      passwordCharacters.add(_randomCharacter(allCharacters));
    }

    _secureShuffle(passwordCharacters);

    return passwordCharacters.join();
  }

  static String _randomCharacter(String characters) {
    return characters[_random.nextInt(characters.length)];
  }

  static void _secureShuffle(List<String> characters) {
    for (var index = characters.length - 1; index > 0; index--) {
      final randomIndex = _random.nextInt(index + 1);

      final currentCharacter = characters[index];

      characters[index] = characters[randomIndex];

      characters[randomIndex] = currentCharacter;
    }
  }
}
