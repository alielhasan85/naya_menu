import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/login/cl_auth_page.dart';
import 'package:naya_menu/client/widgets/language_menu.dart';
import 'package:naya_menu/service/lang/localization.dart';
import 'package:naya_menu/service/providers/lang_provider.dart';
import 'package:naya_menu/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetStartedPage extends ConsumerWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage =
        ref.watch(languageProvider); // Watch the selected language

    return Scaffold(
      appBar: AppBar(
        title: const Text('Naya Menu'),
        actions: [
          LanguageMenu(
            languages: [
              'English',
              'Arabic'
            ], // Provide the list of available languages
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('app_name'),
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.translate('tagline'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightText,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 300, // Limit width to avoid overflow
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.white,
                      backgroundColor: AppTheme.grey,
                      textStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                                color: AppTheme.white,
                              ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('sign_in_button'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
