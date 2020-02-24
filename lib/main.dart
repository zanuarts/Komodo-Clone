 import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_ui/login/login_page.dart';
import 'package:komodo_ui/repository/api_repository.dart';
import 'package:komodo_ui/repository/repository.dart';
import 'package:komodo_ui/authentication/authentication.dart';
import 'package:komodo_ui/splash/splash.dart';
import 'package:komodo_ui/home/home.dart';
import 'package:komodo_ui/common/common.dart';
import 'package:komodo_ui/repository/api_client.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  final ApiRepository apiRepository = ApiRepository(apiFactory: ApiFactory(httpClient: http.Client()));

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: App(userRepository: userRepository,apiRepository:apiRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  final ApiRepository apiRepository;
  App({Key key, @required this.userRepository, @required this.apiRepository}) :assert(apiRepository != null), super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return HomePage(apiRepository:apiRepository);
            
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(userRepository: userRepository);
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      ),
    );
  }
}