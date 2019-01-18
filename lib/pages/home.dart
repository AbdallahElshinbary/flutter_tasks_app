import 'package:flutter/material.dart';
import '../ui/clippers/day_clipper.dart';
import '../blocs/bloc_provider.dart';
import '../blocs/group_bloc.dart';
import '../blocs/task_bloc.dart';
import '../model/group.dart';
import '../ui/helpers/no_tasks.dart';
import '../ui/helpers/menu_fab.dart';
import '../ui/items/group_item.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  GroupBloc groupBloc;
  TaskBloc taskBloc;

  @override
  void initState() {
    super.initState();
    groupBloc = BlocProvider.of<GroupBloc>(context);
    taskBloc = BlocProvider.of<TaskBloc>(context);
    _read();
  }

  _read() async {
    await groupBloc.getAll();
    await taskBloc.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: DayClipper(),
            child: Container(
              height: 250.0,
              width: double.infinity,
              padding: EdgeInsets.only(left: 30.0, top: 70.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFED5AC3), Colors.purpleAccent],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Text(
                "MY TASKS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60.0,
                  color: Colors.white,
                  fontFamily: "Scada",
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: StreamBuilder(
              stream: groupBloc.groupStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final List<Group> groups = snapshot.data;
                  if (groups.isEmpty) {
                    return NoTasks();
                  }
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: groups.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return SizedBox(height: 150.0);
                      } else {
                        return GroupItem(group: groups[index - 1]);
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Color(0xFFED5AC3)),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: MenuFAB(),
          ),
        ],
      ),
    );
  }
}
