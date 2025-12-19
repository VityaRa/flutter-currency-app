import 'package:flutter/material.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/app/utils/theme_mode_ext.dart';
import 'package:lr4/domain/model/app_theme_mode.dart';
import 'package:lr4/domain/model/data_source.dart';
import 'package:lr4/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';

part 'theme_mode_selector_bs.dart';
part 'data_source_selector_bs.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ValueNotifier<AppThemeMode> _themeModeNotifier = 
      ValueNotifier(_settingsRepository.themeMode);
  late final ValueNotifier<DataSource> _dataSourceNotifier = 
      ValueNotifier(_settingsRepository.dataSource);

  SettingsRepository get _settingsRepository => context.read<SettingsRepository>();

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    _dataSourceNotifier.dispose();
    super.dispose();
  }

  Future<void> _clearCache(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистка кэша'),
        content: const Text(
          'Вы уверены, что хотите очистить все сохранённые данные? '
          'При следующем запуске приложения данные будут загружены заново.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Очистить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        // Очищаем кэш через репозитории
        await _settingsRepository.clearAllCache();
        
        // Показываем уведомление об успехе
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Кэш успешно очищен'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Показываем уведомление об ошибке
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Ошибка при очистке кэша: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Настройка темы
            ValueListenableBuilder(
              valueListenable: _themeModeNotifier,
              builder: (BuildContext context, AppThemeMode mode, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.dark_mode),
                  title: child,
                  subtitle: Text(
                    mode.title,
                    style: fonts.regular12,
                  ),
                  onTap: () async {
                    final AppThemeMode? newMode = 
                        await ThemeModeSelectorBottomSheet.show(context, mode);
                    if (newMode == null) return;

                    _themeModeNotifier.value = newMode;
                  },
                );
              },
              child: Text(
                'Тема',
                style: fonts.regular16,
              ),
            ),
            
            // Настройка источника данных
            ValueListenableBuilder(
              valueListenable: _dataSourceNotifier,
              builder: (BuildContext context, DataSource source, Widget? child) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 24),
                  leading: const Icon(Icons.storage),
                  title: child,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source.name,
                        style: fonts.regular12,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        source.name,
                        style: fonts.regular12.copyWith(
                          color: colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final DataSource? newSource = 
                        await DataSourceSelectorBottomSheet.show(context, source);
                    if (newSource == null) return;

                    _dataSourceNotifier.value = newSource;
                  },
                );
              },
              child: Text(
                'Источник данных',
                style: fonts.regular16,
              ),
            ),
            
            // Очистка кэша
            ListTile(
              contentPadding: const EdgeInsets.only(left: 24),
              leading: Icon(Icons.delete_outline, color: colors.red),
              title: Text(
                'Очистить кэш',
                style: fonts.regular16,
              ),
              subtitle: Text(
                'Удалить все сохранённые данные',
                style: fonts.regular12.copyWith(color: colors.grey),
              ),
              onTap: () => _clearCache(context),
            ),
            
            const Spacer(),
            
            // Кнопка выхода
            ElevatedButton(
              onPressed: () => context.read<SettingsRepository>().setToken(null),
              child: Text(
                'Выйти',
                style: fonts.regular14.copyWith(color: context.colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}