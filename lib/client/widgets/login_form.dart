import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naya_menu/client/screens/main_screen.dart';
import 'package:naya_menu/client/widgets/input_decoration.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailEditorController,
    required TextEditingController passwordEditorController,
  })  : _formKey = formKey,
        _emailEditorController = emailEditorController,
        _passwordEditorController = passwordEditorController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailEditorController;
  final TextEditingController _passwordEditorController;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please add an email';
                  }

                  return null;
                },
                controller: _emailEditorController,
                decoration: buildInputDecoration('Enter Email', 'john@me.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter password';
                  }

                  return null;
                },
                controller: _passwordEditorController,
                obscureText: true,
                decoration: buildInputDecoration('Password', ''),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission if valid

                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailEditorController.text,
                            password: _passwordEditorController.text)
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreenPage(),
                        ),
                      );
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ))
          ],
        ));
  }
}
