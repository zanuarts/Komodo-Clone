import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komodo_ui/blocs/blocs.dart';
import 'package:komodo_ui/repository/repository.dart';
import 'package:komodo_ui/home/home_page.dart';

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
