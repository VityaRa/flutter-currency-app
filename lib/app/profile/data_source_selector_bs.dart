part of 'profile_page.dart';

class DataSourceSelectorBottomSheet extends StatelessWidget {
  const DataSourceSelectorBottomSheet._({required this.selectedSource});

  final DataSource selectedSource;

  static Future<DataSource?> show(BuildContext context, DataSource selectedSource) => 
    showModalBottomSheet(
      context: context,
      builder: (_) => DataSourceSelectorBottomSheet._(selectedSource: selectedSource),
    );

  @override
  Widget build(BuildContext context) {
    final ThemeColors colors = context.colors;
    final ThemeFonts fonts = context.fonts;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final DataSource source in DataSource.values)
            RadioListTile(
              value: source,
              groupValue: selectedSource,
              onChanged: (DataSource? source) {
                if (source == null) return;

                context.read<SettingsRepository>().setDataSource(source);

                Navigator.pop(context, source);
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source.name,
                    style: fonts.regular16,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
        ],
      ),
    );
  }
}