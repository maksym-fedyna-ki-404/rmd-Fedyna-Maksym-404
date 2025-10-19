import 'package:flutter/material.dart';
import 'package:my_project/constants/magic_commands.dart';
import 'package:my_project/services/command_processor.dart';
import 'package:my_project/widgets/command_input.dart';
import 'package:my_project/widgets/command_list.dart';
import 'package:my_project/widgets/counter_display.dart';
import 'package:my_project/widgets/status_message.dart';

void main() {
  runApp(const MyApp());
}

/// Головний віджет додатку
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TextConstants.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ThemeConstants.defaultThemeColor,
        ),
        useMaterial3: true,
      ),
      home: const MagicControllerPage(title: TextConstants.appTitle),
    );
  }
}

/// Головна сторінка магічного контролера
class MagicControllerPage extends StatefulWidget {
  const MagicControllerPage({required this.title, super.key});

  final String title;

  @override
  State<MagicControllerPage> createState() => _MagicControllerPageState();
}

/// Стан головної сторінки
class _MagicControllerPageState extends State<MagicControllerPage>
    with SingleTickerProviderStateMixin {
  // Бізнес-логіка
  final CommandProcessor _commandProcessor = CommandProcessor();

  // Стан додатку
  int _counter = 0;
  String _statusMessage = TextConstants.defaultStatusMessage;
  Color _backgroundColor = ThemeConstants.defaultThemeColor;
  bool _isGlowing = false;

  // Контролери
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Ініціалізує анімацію
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: AnimationConstants.counterAnimationDuration,
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(
          begin: AnimationConstants.scaleAnimationBegin,
          end: AnimationConstants.scaleAnimationEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  /// Обробляє введення команди
  void _processInput() {
    final input = _textController.text.trim();
    final result = _commandProcessor.processCommand(input, _counter);

    setState(() {
      _counter = result.newCounterValue;
      _statusMessage = result.message;

      // Оновлюємо колір фону, якщо вказано
      if (result.newBackgroundColor != null) {
        _backgroundColor = result.newBackgroundColor!;
      }

      // Перемикаємо підсвітку, якщо потрібно
      if (result.shouldToggleGlow != null) {
        _isGlowing = result.shouldToggleGlow!;
      }

      // Анімуємо лічильник, якщо потрібно
      if (result.shouldAnimate) {
        _animateCounter();
      }
    });

    _textController.clear();
  }

  /// Запускає анімацію лічильника
  void _animateCounter() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  /// Збільшує лічильник на 1
  void _incrementCounter() {
    setState(() {
      _counter++;
      _statusMessage = 'Лічильник збільшено: $_counter';
      _animateCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Створює AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      elevation: UIConstants.elevationMedium,
    );
  }

  /// Створює тіло сторінки
  Widget _buildBody() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _backgroundColor.withAlpha(UIConstants.alphaLight),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(UIConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: UIConstants.paddingExtraLarge),
              _buildCounter(),
              const SizedBox(height: UIConstants.paddingExtraLarge),
              _buildCommandInput(),
              const SizedBox(height: UIConstants.paddingLarge),
              _buildStatusMessage(),
              const SizedBox(height: UIConstants.paddingExtraLarge),
              _buildCommandList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Створює заголовок
  Widget _buildTitle() {
    return const Text(
      TextConstants.counterTitle,
      style: TextStyle(
        fontSize: UIConstants.titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Створює дисплей лічильника
  Widget _buildCounter() {
    return CounterDisplay(
      counter: _counter,
      animation: _scaleAnimation,
      backgroundColor: _backgroundColor,
      isGlowing: _isGlowing,
    );
  }

  /// Створює поле вводу команд
  Widget _buildCommandInput() {
    return CommandInput(
      controller: _textController,
      onSubmit: _processInput,
      backgroundColor: _backgroundColor,
    );
  }

  /// Створює віджет статус-повідомлення
  Widget _buildStatusMessage() {
    return StatusMessage(
      message: _statusMessage,
      backgroundColor: _backgroundColor,
    );
  }

  /// Створює список команд
  Widget _buildCommandList() {
    return const CommandList();
  }

  /// Створює FloatingActionButton
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: TextConstants.incrementTooltip,
      backgroundColor: _backgroundColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
