import 'package:flutter/material.dart';
import '../../blocs/bloc_provider.dart';
import '../../blocs/group_bloc.dart';
import '../../blocs/task_bloc.dart';
import '../../model/group.dart';
import '../../model/task.dart';
import '../items/task_item.dart';
import '../tick/tick_overlay.dart';
import '../helpers/dialogs.dart';

enum Choice { edit, delete }

class GroupItem extends StatefulWidget {
  final Group group;

  const GroupItem({Key key, this.group}) : super(key: key);

  @override
  GroupItemState createState() => GroupItemState();
}

class GroupItemState extends State<GroupItem> {
  GroupBloc groupBloc;
  TaskBloc taskBloc;
  TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool deleteTime = false;
  Icon removeIcon = Icon(Icons.remove_circle_outline);

  @override
  void initState() {
    super.initState();
    groupBloc = BlocProvider.of<GroupBloc>(context);
    taskBloc = BlocProvider.of<TaskBloc>(context);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _dialogCallback() async {
    await taskBloc.saveTask(Task(_textEditingController.text, false, widget.group.id));
    _textEditingController.clear();
    Navigator.of(context).pop();
    showTickOverlay(context);
  }

  void _editCallback(int color) async {
    Group newGroup = Group.fromMap({
      'id': widget.group.id,
      'name': _textEditingController.text,
      'color': color,
    });
    await groupBloc.editGroup(newGroup);
    Navigator.of(context).pop();
  }

  void _deleteCallback() async {
    await groupBloc.deleteGroup(widget.group.id);
    await taskBloc.getAll();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 30.0, right: 30.0),
          margin: EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: taskBloc.taskStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<Task> tasks = snapshot.data.where((task) => task.groupId == widget.group.id).toList();
                return Column(
                  children: tasks.map((task) => TaskItem(task: task, deleteTime: deleteTime)).toList(),
                );
              }
              return Container();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0, left: 35.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Color(widget.group.color),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            widget.group.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20.0),
          ),
        ),
        Positioned(
          right: 30.0,
          top: 30.0,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                ),
                iconSize: 25.0,
                onPressed: () {
                  showAddEditDialog(
                    context: context,
                    title: "New Task",
                    label: "Task Title",
                    hint: "Enter the title here",
                    controller: _textEditingController,
                    formKey: _formKey,
                    isGroup: false,
                    callback: _dialogCallback,
                  );
                },
              ),
              IconButton(
                icon: removeIcon,
                iconSize: 25.0,
                onPressed: () {
                  setState(() {
                    if (!deleteTime) {
                      deleteTime = true;
                      removeIcon = Icon(Icons.done_all, color: Colors.red);
                    } else {
                      deleteTime = false;
                      removeIcon = Icon(Icons.remove_circle_outline);
                    }
                  });
                },
              ),
              PopupMenuButton<Choice>(
                onSelected: (Choice result) {
                  if (result == Choice.edit) {
                    showAddEditDialog(
                      context: context,
                      title: "Edit Group",
                      label: "Group Title",
                      hint: "Enter the group name here",
                      controller: _textEditingController,
                      formKey: _formKey,
                      isGroup: true,
                      groupColor: widget.group.color,
                      groupTitle: widget.group.name,
                      callback: _editCallback,
                    );
                  } else if (result == Choice.delete) {
                    showDeleteDialog(context: context, callback: _deleteCallback, all: false);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<Choice>>[
                    PopupMenuItem<Choice>(
                      value: Choice.edit,
                      child: Text("Edit group"),
                    ),
                    PopupMenuItem<Choice>(
                      value: Choice.delete,
                      child: Text("Delete group", style: TextStyle(color: Colors.red)),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
