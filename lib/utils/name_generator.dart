import 'dart:math';

class NameGenerator {
  static const List<String> _prefixes = [
    'Void',
    'Last',
    'Echo',
    'Neon',
    'Dark',
    'Ghost',
    'Silent',
    'Cyber',
    'Null',
    'Static',
    'Shadow',
    'Bleak',
    'Lost',
    'Final',
    'Fading',
    'Zero',
    'Bitter',
    'Cold',
    'Dead',
    'Grim',
  ];

  static const List<String> _suffixes = [
    'Walker',
    'Breath',
    'Spirit',
    'Soul',
    'Signal',
    'Pulse',
    'Edge',
    'Byte',
    'Point',
    'Flame',
    'Ghost',
    'Shadow',
    'Light',
    'Echo',
    'Drifter',
    'Heart',
    'End',
    'Path',
    'Mind',
    'Wire',
  ];

  static String generate() {
    final random = Random();
    final prefix = _prefixes[random.nextInt(_prefixes.length)];
    final suffix = _suffixes[random.nextInt(_suffixes.length)];
    return '$prefix$suffix';
  }
}
