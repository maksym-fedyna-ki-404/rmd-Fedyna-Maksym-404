import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';

/// Віджет для відображення лічильника з анімацією
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({
    required this.counter,
    required this.animation,
    required this.backgroundColor,
    required this.isGlowing,
    super.key,
  });

  final int counter;
  final Animation<double> animation;
  final Color backgroundColor;
  final bool isGlowing;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        padding: const EdgeInsets.all(UIConstants.paddingExtraLarge),
        decoration: BoxDecoration(
          color: backgroundColor.withAlpha(UIConstants.alphaMedium),
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withAlpha(UIConstants.alphaHeavy),
              blurRadius: isGlowing ? 20 : 10,
              spreadRadius: isGlowing ? 5 : 2,
            ),
          ],
        ),
        child: Text(
          '$counter',
          style: TextStyle(
            fontSize: UIConstants.counterFontSize,
            fontWeight: FontWeight.bold,
            color: backgroundColor,
          ),
        ),
      ),
    );
  }
}
