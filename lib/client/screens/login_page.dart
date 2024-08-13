import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:naya_menu/client/widgets/create_account_form.dart';
import 'package:naya_menu/client/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCreateAccountClicked = false;
  final _formKey = GlobalKey<FormState>();
  final _emailEditorController = TextEditingController();
  final _passwordEditorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: HexColor('#b9c2d1'),
            ),
          ),
          Text(
            'Sign In',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: isCreateAccountClicked
                    ? LoginForm(
                        formKey: _formKey,
                        emailEditorController: _emailEditorController,
                        passwordEditorController: _passwordEditorController)
                    : CreatAccountForm(
                        formKey: _formKey,
                        emailEditorController: _emailEditorController,
                        passwordEditorController: _passwordEditorController),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: HexColor('#fd5b28'),
                    textStyle: const TextStyle(
                        fontSize: 18, fontStyle: FontStyle.italic)),
                onPressed: () {
                  setState(() {
                    if (isCreateAccountClicked == false) {
                      isCreateAccountClicked = true;
                    } else {
                      isCreateAccountClicked = false;
                    }
                  });
                },
                icon: const Icon(Icons.portrait_rounded),
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  child: Text(isCreateAccountClicked
                      ? 'Create Account'
                      : 'Already Have account'),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: HexColor('#b9c2d1'),
            ),
          )
        ],
      ),
    );
  }
}
