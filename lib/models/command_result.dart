import 'package:flutter/material.dart';

/// Результат виконання команди
@immutable
class CommandResult {
  const CommandResult({
    required this.newCounterValue,
    required this.message,
    required this.messageColor,
    this.newBackgroundColor,
    this.shouldAnimate = false,
    this.shouldToggleGlow,
  });

  /// Нове значення лічильника
  final int newCounterValue;

  /// Повідомлення для користувача
  final String message;

  /// Колір повідомлення
  final Color messageColor;

  /// Новий колір фону (опціонально)
  final Color? newBackgroundColor;

  /// Чи потрібно анімувати лічильник
  final bool shouldAnimate;

  /// Чи потрібно перемкнути підсвітку (null = не змінювати)
  final bool? shouldToggleGlow;

  /// Створює копію з можливістю змінити деякі поля
  CommandResult copyWith({
    int? newCounterValue,
    String? message,
    Color? messageColor,
    Color? newBackgroundColor,
    bool? shouldAnimate,
    bool? shouldToggleGlow,
  }) {
    return CommandResult(
      newCounterValue: newCounterValue ?? this.newCounterValue,
      message: message ?? this.message,
      messageColor: messageColor ?? this.messageColor,
      newBackgroundColor: newBackgroundColor ?? this.newBackgroundColor,
      shouldAnimate: shouldAnimate ?? this.shouldAnimate,
      shouldToggleGlow: shouldToggleGlow ?? this.shouldToggleGlow,
    );
  }
}

