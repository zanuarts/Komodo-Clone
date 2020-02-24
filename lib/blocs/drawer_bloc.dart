import 'dart:async';

class DrawerBloc{
  final navController = StreamController();
  NavProvider navProvider = new NavProvider();
  Stream get getNav => navController.stream;

  void updateNav(String nav){
    navProvider.updateNav(nav);
    navController.sink.add(navProvider.currentNav);
  }

  void dispose(){
    navController.close();
  }
}

class NavProvider{
  String currentNav ="Home";

  void updateNav(String nav){
    currentNav = nav;
  }
}