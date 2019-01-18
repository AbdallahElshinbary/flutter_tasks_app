import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/group_bloc.dart';
import '../blocs/task_bloc.dart';
import 'splash.dart';
import 'home.dart';

class App extends StatelessWidget {
  Future<bool> _splash() async {
    final prefs = await SharedPreferences.getInstance();
    bool show = prefs.getBool("splash") ?? true;
    if(show) {
      prefs.setBool("splash", false);
    }
    return show;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _splash(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return SplashScreen();
          } else {
            return BlocProvider<GroupBloc>(
              bloc: GroupBloc(),
              child: BlocProvider<TaskBloc>(
                bloc: TaskBloc(),
                child: MyHomePage(),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}
