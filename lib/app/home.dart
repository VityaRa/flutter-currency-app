
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lr4/app/news_list/news_list_page.dart';
import 'package:lr4/app/home/home_cubit.dart'; 
import 'package:lr4/app/currency_list/currency_list_page.dart';
import 'package:lr4/app/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = <Widget>[
    CurrencyListPage(), // 0 Вкладка "Курс Валют"
    NewsListPage(), // 1 Вкладка "Новости"
  ];

  @override
  Widget build(BuildContext context) {
    // Внешний BlocBuilder для HomeCubit (индекс вкладки)
    return BlocBuilder<HomeCubit, HomeState>( // HomeState доступен через импорт HomeCubit
      builder: (homeContext, homeState) {  
            final int selectedIndex = homeState.selectedIndex;
           
            return Scaffold(
              body: IndexedStack(
                index: selectedIndex,
                children: _pages,
              ),
              
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: selectedIndex,
                 onTap: (index) {
                  // 1. Проверяем, если пользователь нажал на уже активную вкладку
                  if (index == selectedIndex) {
                    // 2. РЕАЛИЗАЦИЯ POP TO ROOT:
                    // Сбрасываем стек навигации до корневого экрана (/home).
                    // Это очищает все экраны, открытые поверх HomePage
                    // и возвращает пользователя к основному виду активной вкладки.
                    Navigator.popUntil(
                      homeContext, 
                      ModalRoute.withName(AppRoutes.home),
                    );

                  } else {
                    // 3. Если нажата другая вкладка, просто переключаемся
                    homeContext.read<HomeCubit>().selectTab(index);
                  }
                },
                items: const [ // Добавляем const для оптимизации
                  BottomNavigationBarItem(
                    icon: const TabWidget(assetPath: 'assets/icons/home.png', isSelected: false),
                    activeIcon: const TabWidget(assetPath: 'assets/icons/home.png', isSelected: true),
                    label: 'Курс Валют',
                  ),
                  BottomNavigationBarItem(
                    icon: const TabWidget(assetPath: 'assets/icons/news.png', isSelected: false),
                    activeIcon: const TabWidget(assetPath: 'assets/icons/news.png', isSelected: true),
                    label: 'Новости',
                  ),
                ],
                // Fix для TabWidget, так как теперь он должен сам определять состояние
                type: BottomNavigationBarType.fixed, // Добавляем, чтобы избежать проблем
              ),
            );
          },
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    required this.assetPath,
    required this.isSelected,
  });
  final String assetPath;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomBarTheme = Theme.of(context).bottomNavigationBarTheme;
    return SizedBox.square(
      dimension: 24,
      child: Image.asset(
        assetPath,
        color: isSelected ? bottomBarTheme.selectedItemColor : bottomBarTheme.unselectedItemColor,
      ),
    );
  }
}