// lib/widgets/release_countdown_banner.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lr4/app/utils/context_ext.dart';
import 'package:lr4/app/utils/release_countdown.dart';

class ReleaseCountdownBanner extends StatefulWidget {
  final String locale;
  
  const ReleaseCountdownBanner({super.key, required this.locale});
  
  @override
  State<ReleaseCountdownBanner> createState() => _ReleaseCountdownBannerState();
}

class _ReleaseCountdownBannerState extends State<ReleaseCountdownBanner> {
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    // Обновляем каждый день в полночь
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final text = ReleaseCountdown.getReleaseDate(widget.locale);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            context.colors.appBarBackground,
            context.colors.appBarSurfaceTint,
          ],
        ),
        border: Border.all(color: context.colors.appBarSurfaceTint),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIcon(text),
              color: context.colors.secondary,

            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: context.colors.secondary,
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }
  
  IconData _getIcon(String text) {
    if (text.contains('сегодня') || text.contains('hoy') || text.contains('today')) {
      return Icons.celebration;
    }
    if (text.contains('состоялся') || text.contains('lanzó') || text.contains('released')) {
      return Icons.rocket_launch;
    }
    return Icons.access_time;
  }
}