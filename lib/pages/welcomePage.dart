import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timywebapp/authentication/auth_service.dart';
import 'package:timywebapp/style/loading.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey[800],
                          ),
                          Center(
                            child: Text('Timytime',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(200.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        _emailField(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _passwordField(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _signInBtn(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _emailField() {
    return TextFormField(
      controller: emailController,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          fillColor: Colors.yellow,
          filled: true,
          hintText: 'Enter your email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
      validator: (val) => val.isEmpty ? 'Enter an email' : null,
      // onChanged: (val) {
      //   setState(() => email = val);
      // }
    );
  }

  _passwordField() {
    return TextFormField(
      controller: passwordController,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
          fillColor: Colors.yellow,
          filled: true,
          hintText: 'Enter your password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
      validator: (val) =>
          val.length < 6 ? 'Enter a password 6+ chars long' : null,
      obscureText: true,
      // onChanged: (val) {
      //   setState(() => password = val);
      // }
    );
  }

  _signInBtn() {
    return RaisedButton(
      color: Colors.yellowAccent,
      child: Text(
        'Sign in',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        setState(() {
          loading = true;
        });
        context.read<AuthenticationService>().signIn(
              email: emailController.text,
              password: passwordController.text,
            );
      },
    );
  }
}
