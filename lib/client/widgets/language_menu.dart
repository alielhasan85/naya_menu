import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/providers/lang_provider.dart';
import 'package:naya_menu/theme/app_theme.dart';

class LanguageMenu extends ConsumerWidget {
  final List<String> languages;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color iconColor;

  const LanguageMenu({
    required this.languages,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    // Get the index of the current language
    int currentIndex = languages.indexOf(currentLanguage);

    // If the current language is not found, default to the first language
    if (currentIndex == -1) {
      currentIndex = 0;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      child: IconButton(
        icon: Icon(
          Icons.language,
          color: iconColor,
        ),
        onPressed: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
            items: List.generate(languages.length, (index) {
              return PopupMenuItem<int>(
                value: index,
                child: Text(
                  languages[index],
                  style: TextStyle(color: iconColor),
                ),
                onTap: () {
                  ref
                      .read(languageProvider.notifier)
                      .setLanguage(languages[index]);
                },
              );
            }),
          );
        },
      ),
    );
  }
}
