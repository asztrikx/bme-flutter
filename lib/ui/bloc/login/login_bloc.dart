import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/ui/bloc/login/TokenManager.dart';
import 'package:flutter_homework/ui/bloc/login/loginResponse.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var dio = GetIt.I<Dio>();
  var tokenMngr = GetIt.I<TokeManager>();

  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if (state is LoginLoading) return;

      emit(LoginLoading());
      try {
        var result = await dio.post("/login", data: {
          "email": event.email,
          "password": event.password,
        });
        if (event.rememberMe) {
          var loginReponse = LoginResponse.fromJson(result.data);
          var token = loginReponse.token!;
          await tokenMngr.setToken(token);
        }
        emit(LoginSuccess());
        emit(LoginForm());
      } on DioError catch(e) {
        var loginReponse = LoginResponse.fromJson(e.response!.data);
        emit(LoginError(loginReponse.message!));
        emit(LoginForm());
      }
    });

    on<LoginAutoLoginEvent>((event, emit) async {
      if (tokenMngr.hasToken()) {
        emit(LoginSuccess());
      }
    });
  }
}