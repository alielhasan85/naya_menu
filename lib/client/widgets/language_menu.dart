import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/service/lang/lang_provider.dart';

class LanguageMenu extends ConsumerStatefulWidget {
  final List<String> languages;
  final BorderRadius? borderRadius;
  final Color backgroundColor;
  final Color textColor;

  const LanguageMenu({
    required this.languages,
    this.borderRadius,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  _LanguageMenuState createState() => _LanguageMenuState();
}

class _LanguageMenuState extends ConsumerState<LanguageMenu>
    with SingleTickerProviderStateMixin {
  late GlobalKey _key;
  bool isMenuOpen = false;
  late Offset buttonPosition;
  late Size buttonSize;
  late double menuWidth;
  OverlayEntry? _overlayEntry;
  late BorderRadius _borderRadius;
  late AnimationController _animationController;
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("language_button");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Find the position and size of the button to display the dropdown correctly
  void findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);

    // Calculate the required width based on the longest language string
    menuWidth = buttonSize.width;
    for (String language in widget.languages) {
      final textPainter = TextPainter(
        text: TextSpan(text: language, style: const TextStyle(fontSize: 16)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: double.infinity);

      if (textPainter.width > menuWidth) {
        menuWidth = textPainter.width + 32; // Add padding
      }
    }
  }

  // Close the dropdown menu
  void closeMenu() {
    _overlayEntry?.remove();
    _animationController.reverse();
    isMenuOpen = !isMenuOpen;
  }

  // Open the dropdown menu
  void openMenu() {
    findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    selectedLanguage =
        ref.watch(languageProvider); // Watch the current language

    return GestureDetector(
      key: _key,
      onTap: () {
        if (isMenuOpen) {
          closeMenu();
        } else {
          openMenu();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: _borderRadius,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLanguage,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 16,
              ),
            ),
            Icon(
              isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: widget.textColor,
            ),
          ],
        ),
      ),
    );
  }

  // Build the dropdown menu using an OverlayEntry
  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: menuWidth,
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: _animationController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: const Offset(0, 0),
                ).animate(_animationController),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: _borderRadius,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.languages.map((language) {
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(languageProvider.notifier)
                              .setLanguage(language); // Update the language
                          closeMenu(); // Close the menu after selection
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          width: menuWidth,
                          child: Text(
                            language,
                            style: TextStyle(
                              color: widget.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
