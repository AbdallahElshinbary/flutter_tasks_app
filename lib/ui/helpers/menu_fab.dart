import 'package:flutter/material.dart';
import '../../utils/string_to_hex.dart';
import '../../blocs/bloc_provider.dart';
import '../../blocs/group_bloc.dart';
import '../../model/group.dart';
import '../tick/tick_overlay.dart';
import 'dialogs.dart';

class MenuFAB extends StatefulWidget {
  @override
  _MenuFABState createState() => _MenuFABState();
}

class _MenuFABState extends State<MenuFAB> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Animation<double> _animateTranslate;
  double _fabHeight = 56.0;
  bool _isOpened = false;
  bool _newGroup = false, _deleteAll = false, _aboutApp = false;

  TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _defaultGroupColor = hexToInt("FF2B285A");

  GroupBloc groupBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateTranslate = Tween<double>(begin: _fabHeight, end: -14.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.bounceIn,
      ),
    );
    _animateTranslate.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (_newGroup) {
          _newGroup = false;
          showAddEditDialog(
            context: context,
            title: "New Group",
            label: "Group Title",
            hint: "Enter the group name here",
            controller: _textEditingController,
            formKey: _formKey,
            isGroup: true,
            groupColor: _defaultGroupColor,
            callback: _dialogCallback,
          );
        } else if (_deleteAll) {
          _deleteAll = false;
          showDeleteDialog(context: context, callback: _deleteAllCallback, all: true);
        } else if (_aboutApp) {
          _aboutApp = false;
          showAboutApp(context);
        }
      }
    });

    groupBloc = BlocProvider.of<GroupBloc>(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _animate() {
    if (!_isOpened)
      _animationController.forward();
    else
      _animationController.reverse();
    _isOpened = !_isOpened;
  }

  void _dialogCallback(int color) async {
    await groupBloc.saveGroup(Group(_textEditingController.text, color));
    _textEditingController.clear();
    Navigator.of(context).pop();
    showTickOverlay(context);
  }

  void _deleteAllCallback() async {
    await groupBloc.deleteAll();
    Navigator.of(context).pop();
  }

  Widget _buildFAB({Function onPressed, IconData icon, double elevation, double factor, String text}) {
    return Transform.translate(
      offset: Offset(0, _animateTranslate.value * factor),
      child: Row(
        children: <Widget>[
          Visibility(
            visible: _isOpened,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.deepPurple,
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                text,
                style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: onPressed,
            child: Icon(icon),
            backgroundColor: Color(0xFF3A3A52),
            elevation: elevation,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        //trick for the offset
        SizedBox(
          height: 50.0,
        ),
        _buildFAB(
          onPressed: () {
            _aboutApp = true;
            _animate();
          },
          icon: Icons.info,
          elevation: 0.0,
          factor: 3.0,
          text: "About App",
        ),
        _buildFAB(
          onPressed: () {
            _deleteAll = true;
            _animate();
          },
          icon: Icons.delete,
          elevation: 0.0,
          factor: 2.0,
          text: "Delete All",
        ),
        _buildFAB(
          onPressed: () {
            _newGroup = true;
            _animate();
          },
          icon: Icons.create_new_folder,
          elevation: 0.0,
          factor: 1.0,
          text: "Add Group",
        ),
        FloatingActionButton(
          backgroundColor: Color(0xFF3D3D52),
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
          onPressed: _animate,
        ),
      ],
    );
  }
}
