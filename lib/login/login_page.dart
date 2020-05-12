import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_ui/login/login_form.dart';
import 'package:komodo_ui/repository/repository.dart';
import 'package:komodo_ui/authentication/authentication.dart';
import 'package:komodo_ui/login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {

  final UserRepository userRepository;

  LoginPage({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  DateTime currentBackPressTime = DateTime.now();

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit');
      return Future.value(false);
    }
    //return Future.value(true);
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        children: <Widget>[
        new Scaffold(
          body: BlocProvider(
            create: (context) {
            return LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              userRepository: widget.userRepository,
              );
            },
            child: LoginForm(),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: FractionalOffset.bottomCenter,
          child: Image(
            image: AssetImage(
            'assets/bg-bawah.png',
            ),
          fit: BoxFit.fill,
        ),
        )
      ],
      ),
    );
  }
}