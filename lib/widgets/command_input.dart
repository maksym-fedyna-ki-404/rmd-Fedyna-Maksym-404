import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';

/// Віджет для введення команд
class CommandInput extends StatelessWidget {
  const CommandInput({
    required this.controller,
    required this.onSubmit,
    required this.backgroundColor,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(UIConstants.alphaHeavy),
            blurRadius: 10,
            spreadRadius: UIConstants.elevationSmall,
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: TextConstants.inputLabel,
              hintText: TextConstants.inputHint,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    UIConstants.borderRadiusSmall,
                  ),
                ),
              ),
              child: const Text(
                TextConstants.executeButtonLabel,
                style: TextStyle(fontSize: UIConstants.buttonFontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
