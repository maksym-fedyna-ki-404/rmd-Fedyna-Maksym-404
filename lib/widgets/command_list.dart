import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';

/// Віджет для відображення списку доступних команд
class CommandList extends StatelessWidget {
  const CommandList({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        TextConstants.commandListTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        // Магічні команди з enum
        ...MagicCommand.values.map(_buildCommandTile),
        // Додаткова команда для чисел
        const ListTile(
          leading: Icon(Icons.add_circle, color: Colors.green),
          title: Text(TextConstants.numberCommandTitle),
          subtitle: Text(TextConstants.numberCommandDescription),
        ),
      ],
    );
  }

  /// Створює ListTile для магічної команди
  Widget _buildCommandTile(MagicCommand command) {
    return ListTile(
      leading: Text(command.emoji, style: const TextStyle(fontSize: 24)),
      title: Text(_capitalize(command.command)),
      subtitle: Text(command.description),
    );
  }

  /// Робить першу букву великою для кожного слова
  String _capitalize(String text) {
    return text
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }
}

