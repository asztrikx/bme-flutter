import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/tokenManager/TokenManager.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:validators/validators.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final emailController = TextEditingController(text: "login@gmail.com");
  final passwordController = TextEditingController(text: "password");
  bool rememberMe = false;
  String? _emailErrorText = null;
  String? _passwordErrorText = null;
  bool loading = false;
  var tokenMngr = GetIt.I.get<TokeManager>();

  set emailErrorText(String? text) {
    setState(() {
      _emailErrorText = text;
    });
  }
  set passwordErrorText(String? text) {
    setState(() {
      _passwordErrorText = text;
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final loginBloc = context.read<LoginBloc>();
    loginBloc.add(LoginAutoLoginEvent());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login page"),
        ),
        body:buildWithScaffold(context),
    );
  }

  Widget buildWithScaffold(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, "/list");
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
        }
      },
      buildWhen: (_, current) {
        return current is LoginForm || current is LoginLoading;
      },
      builder: (context, state) {
        return loginForm(context, state);
      }
    );
  }

  Widget loginForm(BuildContext context, LoginState state) {
    final loginBloc = context.read<LoginBloc>();
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                errorText: _emailErrorText,
              ),
              controller: emailController,
              onChanged: (_) {
                emailErrorText = null;
              },
              enabled: state is! LoginLoading,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                errorText: _passwordErrorText,
              ),
              controller: passwordController,
              onChanged: (_) {
                passwordErrorText = null;
              },
              obscureText: true,
              enabled: state is! LoginLoading,
            ),
            Checkbox(
              value: rememberMe,
              onChanged: (checked) {
                checked!;
                if (state is! LoginLoading) {
                  setState(() {
                    rememberMe = checked;
                  });
                }
              },
            ),
            ElevatedButton(onPressed: () => submit(loginBloc), child: const Text("Submit"))
          ],
        )
    );
  }

  void submit(LoginBloc loginBloc) {
    bool error = false;
    if (!isEmail(emailController.text)) {
      emailErrorText = "Nem email.";
      error = true;
    }
    if (passwordController.text.length < 6) {
      passwordErrorText = "Kisebb mint 6";
      error = true;
    }
    if (error) return;

    loginBloc.add(LoginSubmitEvent(
        emailController.text,
        passwordController.text,
        rememberMe,
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
