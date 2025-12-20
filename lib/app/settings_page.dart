import 'package:flutter/material.dart';
import 'package:lr4/app/app_routes.dart';
import 'package:lr4/app/utils/context_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Асинхронная функция для перехода и обработки результата
  void _navigateAndHandleResult(BuildContext context) async {
    // Используем await для ожидания результата и передаем аргументы
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.resultScreen,
      arguments: {
        'data': context.loc.navigateWithData,
        'number': 42,
      },
    );

    // 2. Проверяем, что результат не null и имеет нужный тип (String)
    if (result != null && result is String) {
      // 3. Отображаем полученный результат в SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.resultReceived(result)),
          duration: const Duration(seconds: 4),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } else if (result == null) {
      // Если пользователь просто нажал кнопку "Назад" на ResultScreen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.noResult),
          duration: const Duration(seconds: 2),
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
          title: Text(context.loc.dialogTitle),
          content: Text(context.loc.dialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, context.loc.operationCancelled),
              child: Text(context.loc.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, context.loc.operationConfirmed),
              child: Text(context.loc.confirmButton),
            ),
          ],
        );
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.resultDialog(result))),
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
                Text(context.loc.bottomSheetTitle),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, context.loc.optionASelected),
                  child: Text(context.loc.optionA),
                )
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.resultBottomSheet(result))),
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
      helpText: context.loc.chooseDate,
      cancelText: context.loc.cancelButton,
      confirmText: context.loc.confirmButton,
    );

    if (picked != null) {
      final date = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.dateSelected(date))),
      );
    }
  }

  // 4. showTimePicker (возвращает TimeOfDay)
  void _showCustomTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: context.loc.chooseTime,
    );

    if (picked != null) {
      final time = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.timeSelected(time))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop(); // Проверяем canPop
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.settings),
      ),
      body: SingleChildScrollView( // Оборачиваем в SingleChildScrollView для безопасности
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- ДЕМОНСТРАЦИЯ ПЕРЕДАЧИ ДАННЫХ В ОБЕ СТОРОНЫ ---
            Text(
              context.loc.dataTransferDemo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _navigateAndHandleResult(context),
              child: Text(context.loc.navigateWithData),
            ),
            const Divider(height: 40),

            Text(
              context.loc.advancedNavigatorMethods,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              child: Text(context.loc.pushNamedAndRemoveUntil),
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
              child: Text(context.loc.popUntil),
            ),
            const SizedBox(height: 10),

            // maybePop (использует canPop)
            ElevatedButton(
              onPressed: canPop
                  ? () async {
                      // Пробуем закрыть экран, выводим результат
                      final didPop = await Navigator.maybePop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.loc.maybePop(canPop.toString())),
                        ),
                      );
                    } : null, // Отключаем кнопку, если нельзя pop
              child: Text(context.loc.maybePop(canPop.toString())),
            ),
            const Divider(height: 40),

            // --- ДЕМОНСТРАЦИЯ МОДАЛЬНЫХ ЭЛЕМЕНТОВ ---
            Text(
              context.loc.modalElementsDemo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Вызов showDialog
            ElevatedButton(
              onPressed: () => _showCustomDialog(context),
              child: Text(context.loc.dialogTitle),
            ),
            const SizedBox(height: 10),

            // Вызов showModalBottomSheet
            ElevatedButton(
              onPressed: () => _showCustomBottomSheet(context),
              child: Text(context.loc.modalBottomSheet),
            ),
            const SizedBox(height: 10),

            // Вызов showDatePicker
            ElevatedButton(
              onPressed: () => _showCustomDatePicker(context),
              child: Text(context.loc.chooseDate),
            ),
            const SizedBox(height: 10),

            // Вызов showTimePicker
            ElevatedButton(
              onPressed: () => _showCustomTimePicker(context),
              child: Text(context.loc.chooseTime),
            ),
          ],
        ),
      ),
    );
  }
}