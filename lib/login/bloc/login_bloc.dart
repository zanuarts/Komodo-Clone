import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:komodo_ui/repository/repository.dart';
import 'package:komodo_ui/authentication/authentication.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );
        if (token == 'failed'){
          yield LoginFailure(error: 'Username/ Password salah.');

        }
        else{
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginInitial();
        }

        
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}