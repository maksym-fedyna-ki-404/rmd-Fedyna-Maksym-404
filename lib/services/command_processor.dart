import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';
import 'package:my_project/models/command_result.dart';

/// Сервіс для обробки команд користувача
class CommandProcessor {
  /// Обробляє введену команду або число
  CommandResult processCommand(String input, int currentCounter) {
    if (input.isEmpty) {
      return CommandResult(
        newCounterValue: currentCounter,
        message: TextConstants.emptyInputMessage,
        messageColor: Colors.orange,
      );
    }

    // Спробувати знайти магічну команду
    final command = MagicCommand.fromString(input);
    if (command != null) {
      return _processMagicCommand(command, currentCounter);
    }

    // Спробувати конвертувати в число
    final number = int.tryParse(input);
    if (number != null) {
      return _processNumber(number, currentCounter);
    }

    // Невідома команда
    return CommandResult(
      newCounterValue: currentCounter,
      message: TextConstants.unknownCommandMessage,
      messageColor: Colors.red,
    );
  }

  /// Обробляє магічну команду
  CommandResult _processMagicCommand(MagicCommand command, int currentCounter) {
    switch (command) {
      case MagicCommand.avadaKedavra:
        return CommandResult(
          newCounterValue: 0,
          message: '${command.emoji} Лічильник знищено! Значення: 0',
          messageColor: Colors.red,
          shouldAnimate: true,
        );

      case MagicCommand.wingardiumLeviosa:
        final newValue = currentCounter * 2;
        return CommandResult(
          newCounterValue: newValue,
          message:
              '${command.emoji} Лічильник піднявся! Нове значення: $newValue',
          messageColor: Colors.blue,
          shouldAnimate: true,
        );

      case MagicCommand.expelliarmus:
        final newValue = (currentCounter / 2).floor();
        return CommandResult(
          newCounterValue: newValue,
          message:
              '${command.emoji} Половину відібрано! Нове значення: $newValue',
          messageColor: Colors.purple,
          shouldAnimate: true,
        );

      case MagicCommand.lumos:
        return CommandResult(
          newCounterValue: currentCounter,
          message: '${command.emoji} Світло увімкнено!',
          messageColor: ThemeConstants.lightColor,
          newBackgroundColor: ThemeConstants.lightColor,
          shouldToggleGlow: true,
        );

      case MagicCommand.nox:
        return CommandResult(
          newCounterValue: currentCounter,
          message: '${command.emoji} Темрява повернулась!',
          messageColor: ThemeConstants.defaultThemeColor,
          newBackgroundColor: ThemeConstants.defaultThemeColor,
          shouldToggleGlow: false,
        );

      case MagicCommand.incendio:
        final newValue = currentCounter + 10;
        return CommandResult(
          newCounterValue: newValue,
          message: '${command.emoji} Вогонь додав +10! Значення: $newValue',
          messageColor: Colors.red,
          newBackgroundColor: ThemeConstants.fireColor,
          shouldAnimate: true,
        );

      case MagicCommand.aguamenti:
        final newValue = currentCounter > 5 ? currentCounter - 5 : 0;
        return CommandResult(
          newCounterValue: newValue,
          message: '${command.emoji} Вода зменшила -5! Значення: $newValue',
          messageColor: Colors.blue,
          newBackgroundColor: ThemeConstants.waterColor,
          shouldAnimate: true,
        );

      case MagicCommand.protego:
        return CommandResult(
          newCounterValue: currentCounter,
          message:
              '${command.emoji} Лічильник захищено! '
              'Поточне значення: $currentCounter',
          messageColor: Colors.green,
        );

      case MagicCommand.alohomora:
        const secretValue = 42;
        return CommandResult(
          newCounterValue: secretValue,
          message: '${command.emoji} Секретне значення відкрито: $secretValue',
          messageColor: Colors.teal,
          shouldAnimate: true,
        );

      case MagicCommand.reducto:
        return CommandResult(
          newCounterValue: 0,
          message: '${command.emoji} Все зруйновано та скинуто!',
          messageColor: Colors.red,
          newBackgroundColor: ThemeConstants.defaultThemeColor,
          shouldAnimate: true,
        );
    }
  }

  /// Обробляє числовий ввід
  CommandResult _processNumber(int number, int currentCounter) {
    final newValue = currentCounter + number;
    return CommandResult(
      newCounterValue: newValue,
      message: '➕ Додано $number! Нове значення: $newValue',
      messageColor: Colors.green,
      shouldAnimate: true,
    );
  }
}

