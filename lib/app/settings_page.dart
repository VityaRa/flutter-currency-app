// app/settings_page.dart

import 'package:flutter/material.dart';
import 'package:lr4/app/app_routes.dart';



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Асинхронная функция для перехода и обработки результата
  void _navigateAndHandleResult(BuildContext context) async {
    // Используем await для ожидания результата и передаем аргументы
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.resultScreen,
      arguments: {
        'data': 'Текст с экрана settings_page.dart',
        'number': 42,
      },
    );

    // 2. Проверяем, что результат не null и имеет нужный тип (String)
    if (result != null && result is String) {
      // 3. Отображаем полученный результат в SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Результат получен: $result'),
          duration: const Duration(seconds: 4),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } else if (result == null) {
       // Если пользователь просто нажал кнопку "Назад" на ResultScreen
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Результат не был выбран.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 1. showDialog (возвращает результат)
  void _showCustomDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Модальное окно'),
          content: const Text('Хотите подтвердить операцию?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Отменено'),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Подтверждено'),
              child: const Text('Подтвердить'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Результат Dialog: $result')),
      );
    }
  }

  // 2. showModalBottomSheet (возвращает результат)
  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Выберите опцию'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'Опция A выбрана'),
                  child: const Text('Опция A'),
                )
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Результат BottomSheet: $result')),
      );
    }
  }

  // 3. showDatePicker (возвращает DateTime)
  void _showCustomDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Выберите дату',
      cancelText: 'Отменить',
      confirmText: 'Готово',
    );

    if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выбрана дата: ${picked.year}-${picked.month}-${picked.day}')),
      );
    }
  }

  // 4. showTimePicker (возвращает TimeOfDay)
  void _showCustomTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Выберите время',
    );

    if (picked != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выбрано время: ${picked.hour}:${picked.minute}')),
      );
    }
  }



@override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop(); // Проверяем canPop
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: SingleChildScrollView( // Оборачиваем в SingleChildScrollView для безопасности
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- ДЕМОНСТРАЦИЯ ПЕРЕДАЧИ ДАННЫХ В ОБЕ СТОРОНЫ ---
            const Text(
              '1. Передача данных в обоих направлениях:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateAndHandleResult(context),
              child: const Text('Перейти на result_screen и передать данные'),
            ),
            const Divider(height: 40),

            const Text(
              '2. Расширенные методы Navigator:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            
            // pushNamedAndRemoveUntil
            ElevatedButton(
              onPressed: () {
                // Переходим на /home, удаляя все экраны из стека навигации
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  (route) => false, // Условие: удаляем все маршруты
                );
              },
              child: const Text('pushNamedAndRemoveUntil (На Главный Экран)'),
            ),
            const SizedBox(height: 10),

            // popUntil
            ElevatedButton(
              onPressed: canPop 
                  ? () {
                    // Удаляем экраны из стека, пока не достигнем /home
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(AppRoutes.home),
                    );
                  } : null, // Отключаем кнопку, если нельзя pop
              child: const Text('popUntil (До Главного Экрана)'),
            ),
            const SizedBox(height: 10),

            // maybePop (использует canPop)
            ElevatedButton(
              onPressed: canPop
                  ? () async {
                      // Пробуем закрыть экран, выводим результат
                      final didPop = await Navigator.maybePop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('maybePop сработало: $didPop')),
                      );
                    } : null, // Отключаем кнопку, если нельзя pop
              child: Text('maybePop (Можно закрыть: $canPop)'),
            ),
            const Divider(height: 40),

            // --- ДЕМОНСТРАЦИЯ МОДАЛЬНЫХ ЭЛЕМЕНТОВ ---
            const Text(
              '3. Модальные элементы и обработка результатов:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Вызов showDialog
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: const Text('Dialog'),
            ),
            const SizedBox(height: 10),

            // Вызов showModalBottomSheet
            ElevatedButton(
              onPressed: () => _showCustomBottomSheet(context),
              child: const Text('Modal Bottom Sheet'),
            ),
            const SizedBox(height: 10),

            // Вызов showDatePicker
            ElevatedButton(
              onPressed: () => _showCustomDatePicker(context),
              child: const Text('Date Picker'),
            ),
            const SizedBox(height: 10),

            // Вызов showTimePicker
            ElevatedButton(
              onPressed: () => _showCustomTimePicker(context),
              child: const Text('Time Picker'),
            ),
          ],
        ),
      ),
    );
  }
}