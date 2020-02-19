import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui1/blocs/blocs.dart';
import 'package:flutter_ui1/repository/repository.dart';
import 'package:flutter_ui1/home/home_page.dart';

class HomePage extends StatelessWidget {
  final ApiRepository apiRepository;
  HomePage({Key key,@required this.apiRepository}):assert(apiRepository != null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create: (context)=> ApiBloc(apiRepository: apiRepository),
        child:Home()
      ),
    );
  }
}
