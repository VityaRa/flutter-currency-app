import 'package:flutter/material.dart';
import 'package:lr4/app/utils/context_ext.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  // Вспомогательная функция для форматирования даты
  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  @override
  Widget build(BuildContext context) {
    // Получение переданных аргументов
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String initialText = args?['data'] as String? ?? context.loc.noGivenData;
    final int initialNumber = args?['number'] as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.returnDataScreen),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Отображение переданных данных
              Text(
                context.loc.passedArguments(initialText, initialNumber),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Text(
                context.loc.clickToReturn,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  final now = DateTime.now();
                  final formattedResult = context.loc.confirmationMessage(_formatDateTime(now));
                  
                  // Возвращаем динамически сгенерированную строку
                  Navigator.pop(context, formattedResult);
                },
                icon: const Icon(Icons.send),
                label: Text(context.loc.returnDataButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}