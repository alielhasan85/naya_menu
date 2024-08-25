import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/login/cl_login_form.dart';
import 'package:naya_menu/client/screens/login/cl_signup_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client/widgets/language_menu.dart';
import 'package:naya_menu/service/lang/localization.dart';
import 'package:naya_menu/theme/app_theme.dart';

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

enum AuthForm { login, signUp }

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEditorController = TextEditingController();
  final _passwordEditorController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailEditorController.dispose();
    _passwordEditorController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormContent(context, ref);
  }

  Widget _buildFormContent(BuildContext context, WidgetRef ref) {
    final authForm = ref.watch(authFormProvider);

    return Material(
      color: AppTheme.background,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const TopDecoration(),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  color: AppTheme.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: authForm == AuthForm.login
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: LoginForm(
                            formKey: _formKey,
                            emailController: _emailEditorController,
                            passwordController: _passwordEditorController,
                            onToggle: () {
                              ref.read(authFormProvider.notifier).state =
                                  AuthForm.signUp;
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: SignUpForm(
                            formKey: _formKey,
                            emailController: _emailEditorController,
                            passwordController: _passwordEditorController,
                            confirmPasswordController:
                                _confirmPasswordController,
                            onToggle: () {
                              ref.read(authFormProvider.notifier).state =
                                  AuthForm.login;
                            },
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 100, // Set a fixed height if needed
              color: AppTheme.lightGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class TopDecoration extends StatelessWidget {
  const TopDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: const BoxDecoration(
          color: AppTheme.lightPeach,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CircleAvatar(
                backgroundColor: Colors.black87,
                backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/1537635/pexels-photo-1537635.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                ),
                radius: 50.0,
              ),
              const SizedBox(height: 10.0),
              Text(
                AppLocalizations.of(context)!.translate('login_page_title'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5.0),
              Text(
                AppLocalizations.of(context)!.translate('login_page_subtitle'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const CircleAvatar(
                backgroundColor: Colors.black87,
                child: Text(
                  ">",
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
              const LanguageMenu(
                languages: ['English', 'Arabic'],
              )
            ],
          ),
        ),
      ),
    );
  }
}
