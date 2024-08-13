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

  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,

              height: null,
              // MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40))
                  // : const BorderRadius.only(
                  //     topLeft: Radius.circular(40),
                  //     bottomLeft: Radius.circular(40),
                  //   )
                  ),
              padding: const EdgeInsets.all(20.0),
              // const EdgeInsets.only(top: 70.0, right: 50.0, left: 50.0),
              child: const Align(
                alignment: Alignment.center,
                // Alignment.centerRight,
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
                        textAlign: TextAlign.center
                        // TextAlign.left,
                        ),
                    SizedBox(height: 5.0),
                    Text(
                      "It should only take a couple of minutes to pair with your watch",
                      style: TextStyle(
                        fontSize: 18.0,
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
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            children: [
              SizedBox(
                height: 350,
                width: 500,
                child: isCreateAccountClicked
                    ? LoginForm(
                        formKey: _formKey,
                        emailController: _emailEditorController,
                        passwordController: _passwordEditorController,
                        onToggle: () {},
                      )
                    : SignUpForm(
                        formKey: _formKey,
                        emailController: _emailEditorController,
                        passwordController: _passwordEditorController,
                        confirmPasswordController: _confirmPasswordController,
                        onToggle: () {}),
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
