import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import '../../blocs/bloc_provider.dart';
import '../../blocs/task_bloc.dart';
import '../../model/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final bool deleteTime;

  const TaskItem({Key key, this.task, this.deleteTime}) : super(key: key);

  @override
  TaskItemState createState() {
    return new TaskItemState();
  }
}

class TaskItemState extends State<TaskItem> {
  bool done = false;
  TaskBloc taskBloc;

  @override
  void initState() {
    super.initState();
    taskBloc = BlocProvider.of<TaskBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskBloc.taskStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              taskBloc.markTask(widget.task);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //check icon
                  Container(
                    height: 25,
                    width: 25,
                    child: ClipPolygon(
                      sides: 8,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        color: widget.task.done ? Colors.green : Colors.grey,
                        child: widget.task.done
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20.0,
                              )
                            : ClipPolygon(
                                sides: 8,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  //task title
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                        color: Color(0xFF4D4D4F),
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        decoration: widget.task.done ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                  ),
                  //delete icon
                  !widget.deleteTime
                      ? Container()
                      : IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            taskBloc.deleteTask(widget.task.id);
                          },
                        ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
