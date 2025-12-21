import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lr4/app/currency_detail/currency_detail_cubit.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/formatters.dart';
import 'package:lr4/app/utils/theme/theme_data.dart';
import 'package:lr4/domain/repository/currency_repository.dart';
import 'package:lr4/domain/service/network_service.dart';

class CurrencyDetailPage extends StatelessWidget {
  final String currencyId;
  final String title;

  const CurrencyDetailPage({
    super.key,
    required this.currencyId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeFonts fonts = context.fonts;
    final ThemeColors colors = context.colors;
    return BlocProvider(
      create: (context) => CurrencyDetailCubit(
        repository: context.read<CurrencyRepository>(),
        networkService: context.read<NetworkService>(),
        currencyId: currencyId,
      )..loadHistory(), // Грузим сразу
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<CurrencyDetailCubit, CurrencyDetailState>(
          builder: (context, state) {
            if (state is CurrencyDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CurrencyDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<CurrencyDetailCubit>().loadHistory(),
                      child: Text(context.loc.repeat),
                    )
                  ],
                ),
              );
            }
            if (state is CurrencyDetailLoaded) {
              final history = state.history;
              return ListView.separated(
                padding: const EdgeInsets.all(22),
                itemCount: history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = history[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          IntlFormatters.formatShortDate(context.loc.localeName, item.date),
                          style: fonts.semiBold12,
                        ),
                        Text(
                          IntlFormatters.convertRubToCurrency(
                              context.loc.localeName, item.value),
                          style: fonts.semiBold12
                              .copyWith(color: colors.blueDepression),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}




















// import 'package:flutter/material.dart';
// import 'package:lr4/app/currency_detail/widgets/currency_info_card.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';


// class CurrencyDetailPage extends StatelessWidget {
//   const CurrencyDetailPage({super.key, required this.title});

//   final String title;

//   static const double _defaultLeadingWidth = 56;
//   static const double _titleSpacing = 24;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: _defaultLeadingWidth + _titleSpacing,
//         titleSpacing: _titleSpacing,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: Text(title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(22, 10, 22, 40),
//         child: Column(
//           children: [
//             for (int i = 0; i < 5; i++)
//               Padding(
//                 padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 10),
//                 child: CurrencyInfoCard(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }