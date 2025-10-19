import 'package:flutter/material.dart';

/// Магічні команди для IoT контролера
enum MagicCommand {
  avadaKedavra('avada kedavra', '💀', 'Скидає лічильник до 0'),
  wingardiumLeviosa('wingardium leviosa', '🪶', 'Множить значення на 2'),
  expelliarmus('expelliarmus', '⚡', 'Ділить значення навпіл'),
  lumos('lumos', '💡', 'Вмикає/вимикає підсвітку'),
  nox('nox', '🌙', 'Вимикає підсвітку'),
  incendio('incendio', '🔥', 'Додає +10 та змінює колір на червоний'),
  aguamenti('aguamenti', '💧', 'Віднімає -5 та змінює колір на синій'),
  protego('protego', '🛡️', 'Захищає (показує поточне значення)'),
  alohomora('alohomora', '🔓', 'Встановлює секретне значення 42'),
  reducto('reducto', '💥', 'Руйнує все та скидає до початку');

  const MagicCommand(this.command, this.emoji, this.description);

  final String command;
  final String emoji;
  final String description;

  /// Знаходить команду за текстом
  static MagicCommand? fromString(String text) {
    final normalized = text.toLowerCase().trim();
    for (final cmd in MagicCommand.values) {
      if (cmd.command == normalized) {
        return cmd;
      }
    }
    return null;
  }
}

/// Константи для анімацій
class AnimationConstants {
  AnimationConstants._();

  static const Duration counterAnimationDuration = Duration(milliseconds: 500);
  static const double scaleAnimationBegin = 1;
  static const double scaleAnimationEnd = 1.2;
}

/// Константи для UI
class UIConstants {
  UIConstants._();

  static const double counterFontSize = 72;
  static const double titleFontSize = 24;
  static const double statusFontSize = 14;
  static const double buttonFontSize = 16;

  static const double paddingSmall = 12;
  static const double paddingMedium = 16;
  static const double paddingLarge = 20;
  static const double paddingExtraLarge = 30;

  static const double borderRadiusSmall = 10;
  static const double borderRadiusMedium = 15;
  static const double borderRadiusLarge = 20;

  static const double elevationSmall = 2;
  static const double elevationMedium = 4;

  static const int alphaLight = 25;
  static const int alphaMedium = 51;
  static const int alphaHeavy = 76;
}

/// Константи для кольорів теми
class ThemeConstants {
  ThemeConstants._();

  static const Color defaultThemeColor = Colors.deepPurple;
  static const Color lightColor = Colors.amber;
  static const Color fireColor = Colors.deepOrange;
  static const Color waterColor = Colors.blue;
}

/// Текстові константи
class TextConstants {
  TextConstants._();

  static const String appTitle = 'Magic IoT Controller 🪄';
  static const String counterTitle = 'Магічний IoT Лічільник';
  static const String defaultStatusMessage =
      'Введіть магічну команду або число';
  static const String emptyInputMessage = 'Спочатку введіть щось! ✨';
  static const String unknownCommandMessage =
      '❌ Невідома команда! Спробуйте магічне заклинання або число';
  static const String incrementTooltip = 'Збільшити на 1';
  static const String executeButtonLabel = 'Виконати команду 🪄';
  static const String inputLabel = 'Введіть команду або число';
  static const String inputHint = 'Наприклад: Lumos, 42, Avada Kedavra';
  static const String commandListTitle = 'Доступні магічні команди 📖';
  static const String numberCommandTitle = 'Число (наприклад, 42)';
  static const String numberCommandDescription = 'Додає число до лічильника';
}

