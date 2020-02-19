import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui1/login/bloc/login_bloc.dart';
import 'package:flutter_ui1/components/inputfield.dart';



class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return new Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: AssetImage(
                      'assets/bg-atas.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Image(
                            image: AssetImage(
                              'assets/logo-text.png',
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          child: Form(
                            //key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 15.0,
                                      shadowColor: Colors.black,
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: new InputFieldArea(
                                        controller: _usernameController,
                                        enableValidation: false,
                                        hint: "Username",
                                        obscure: false,
                                        icon: Icons.person,
                                        suffixIcon: null,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10, left: 8.0, right: 8.0, bottom: 8.0),
                                    child: Material(
                                      elevation: 15.0,
                                      shadowColor: Colors.black,
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: new InputFieldArea(
                                        controller: _passwordController,
                                        enableValidation: false,
                                        hint: "Password",
                                        obscure: showPassword,
                                        icon: Icons.lock_outline,
                                        suffixIcon: IconButton(
                                          icon: showPassword
                                          ? (Icon(Icons.visibility_off, color: Colors.black26))
                                          : (Icon(Icons.visibility, color: Colors.black26)),
                                          onPressed: (){
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Material(
                                      elevation: 10.0,
                                      shadowColor: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: ButtonTheme(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                              new BorderRadius.circular(30.0)),
                                          minWidth: MediaQuery.of(context).size.width / 2,
                                          height: 50,
                                          child: FlatButton(
                                              padding: EdgeInsets.all(5),
                                              color: Colors.deepOrangeAccent,
                                              textColor: Colors.blue,
                                              //  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.blue)),
                                              child: new Text('Login',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              onPressed: state is! LoginLoading ? _onLoginButtonPressed : null,
                                              )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ),
//              Container(
//              margin: EdgeInsets.all(5.0),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                    child:Text(
//                      'Instagram',
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.all(5.0),
//                    child: TextFormField(
//                      autofocus: false,
//                      decoration: InputDecoration(
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        labelText: 'username',
//                        suffixIcon: Icon(
//                          Icons.account_circle,
//                          color : Colors.blue,
//                        ),
//                      ),
//                      controller: _usernameController,
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.all(5.0),
//                    child: TextFormField(
//                      obscureText: true,
//                      decoration: InputDecoration(
//                        border: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        ),
//                        labelText: 'password',
//                        //suffixIcon: GestureDetector(
//
//                        //isDense: true,
//                      ),
//                      controller: _passwordController,
//                      //obscureText: true,
//                    ),
//                  ),
//                  Container(
//                    alignment : Alignment(1.0,0.0),
//
//                      child: Text(
//                          'forgot password?'
//                      ),
//
//                  ),
//                  Container(
//                    padding: EdgeInsets.all(5.0),
//                    child: RaisedButton(
//                      shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(10.0),
//                      ),
//                      color: Colors.blue,
//                      child: Text(
//                        'Log In', style: TextStyle(
//                        color: Colors.white,
//                      ),
//                      ),
//                      onPressed: state is! LoginLoading ? _onLoginButtonPressed : null,
//                    ),
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(top:10.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Text(
//                          "don't have an account?",
//                        ),
//
//                          Text(
//                            'Register here',
//                          ),
//
//                      ],
//                    ),
//                  ),
//                  Container(
//                    child: state is LoginLoading
//                        ? CircularProgressIndicator()
//                        : null,
//                  ),
//                ],
//              ),
//            ),

          ]
          );
        },
      ),
    );
  }
}