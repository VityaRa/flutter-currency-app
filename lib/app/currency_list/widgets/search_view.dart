import 'package:flutter/material.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key, this.onChanged});
  final ValueChanged<String>? onChanged; // Функция обратного вызова

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide(color: colors.grey),
    );

    return TextField(
      onChanged: onChanged,
      style: fonts.regular12,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(13, 9, 11, 9),
          child: SizedBox.square(
            dimension: 20,
            child: Image.asset('assets/icons/search.png'),
          ),
        ),
        hintText: context.loc.search,
        hintStyle: fonts.regular12.copyWith(color: colors.stormyGrey),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.black),
        ),
      ),
    );
  }
}
