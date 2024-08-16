import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:naya_menu/client/screens/login/cl_login_form.dart';
import 'package:naya_menu/client/screens/login/cl_signup_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authFormProvider = StateProvider<AuthForm>((ref) => AuthForm.login);

enum AuthForm { login, signUp }

class LoginPage extends ConsumerStatefulWidget {
  // Extending ConsumerStatefulWidget
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() =>
      _LoginPageState(); // Correct return type
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Extending ConsumerState<LoginPage>
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
    // Implementing the build method
    return _buildFormContent(context, ref);
  }

  Widget _buildFormContent(BuildContext context, WidgetRef ref) {
    final authForm = ref.watch(authFormProvider);

    return Material(
      child: Column(
        children: [
          const TopDecoration(),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Padding around the Card
              child: Card(
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
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: SignUpForm(
                          formKey: _formKey,
                          emailController: _emailEditorController,
                          passwordController: _passwordEditorController,
                          confirmPasswordController: _confirmPasswordController,
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
          Expanded(
            flex: 1,
            child: Container(
              color: HexColor('#b9c2d1'),
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(
            vertical: 20.0), // Add padding to the sides
        decoration: BoxDecoration(
          color: Colors.yellow[600],
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: const Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.black87,
                backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/1537635/pexels-photo-1537635.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                ),
                radius: 50.0,
              ),
              SizedBox(height: 10.0),
              Text("Let's get you set up",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center),
              SizedBox(height: 5.0),
              Text(
                "It should only take a couple of minutes to pair with your watch",
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              CircleAvatar(
                backgroundColor: Colors.black87,
                child: Text(
                  ">",
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
