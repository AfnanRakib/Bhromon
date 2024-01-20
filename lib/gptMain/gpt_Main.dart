import 'package:bhromon/provider/active_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:bhromon/screens/chat_screen.dart';
import 'package:bhromon/constant/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class bhromon_gpt extends ConsumerWidget {
  const bhromon_gpt({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return  MaterialApp(
        theme: lightTheme,
        darkTheme:darkTheme,
        debugShowCheckedModeBanner: false,
        themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light ,
        home:ChatScreen(),
    );
  }
}
