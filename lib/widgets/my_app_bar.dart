import 'package:bhromon/provider/active_theme_provider.dart';
import 'package:bhromon/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        Row(
          children: [
            Consumer(
              builder: (context,ref,child) {
                return Icon(ref.watch(activeThemeProvider)
                    == Themes.dark ? Icons.dark_mode : Icons.light_mode
                );
              }
            ),
            const SizedBox(width: 6,),
            //Switch.adaptive(value: true, onChanged: (value){})
            const ThemeSwitch(),
          ],
        )
      ],
      centerTitle: true,
      title: Text('Welcome to Bhromon AI',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ) ,
    );
  }

  @override

  Size get preferredSize => const Size.fromHeight(60);
}
