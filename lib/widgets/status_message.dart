import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';

/// Віджет для відображення статус-повідомлень
class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.message,
    required this.backgroundColor,
    super.key,
  });

  final String message;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingSmall),
      decoration: BoxDecoration(
        color: backgroundColor.withAlpha(UIConstants.alphaLight),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
        border: Border.all(
          color: backgroundColor.withAlpha(UIConstants.alphaHeavy),
          width: 2,
        ),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: UIConstants.statusFontSize,
          color: backgroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

