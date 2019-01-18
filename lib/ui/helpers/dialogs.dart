import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../utils/string_to_hex.dart';

void showAddEditDialog({
  BuildContext context,
  String title,
  String label,
  String hint,
  TextEditingController controller,
  GlobalKey<FormState> formKey,
  bool isGroup,
  int groupColor,
  String groupTitle,
  Function callback,
}) {
  if (groupTitle != null) {
    controller.text = groupTitle;
  } else {
    controller.text = "";
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: StadiumBorder(),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "BungeeShade",
                        color: Color(0xFFED5AC3)),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Theme(
                        data: ThemeData(primaryColor: Color(0xFFED5AC3)),
                        child: Expanded(
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Title can't be empty!";
                                }
                              },
                              controller: controller,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: label,
                                  hintText: hint,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(15.0)),
                            ),
                          ),
                        ),
                      ),
                      !isGroup
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                Icons.color_lens,
                                color: Color(0xFFED5AC3),
                                size: 35.0,
                              ),
                              onPressed: () {
                                Color choosenColor = Color(groupColor);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Theme(
                                      data: ThemeData(primarySwatch: Colors.blue),
                                      child: AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ColorPicker(
                                            colorPickerWidth: MediaQuery.of(context).size.width,
                                            onColorChanged: (Color value) {
                                              choosenColor = value;
                                            },
                                            pickerColor: choosenColor,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            padding: EdgeInsets.only(right: 15.0),
                                            child: Text(
                                              "Choose Color",
                                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              groupColor = hexToInt(choosenColor
                                                  .toString()
                                                  .substring(8, choosenColor.toString().length - 1));
                                              Navigator.of(context).pop(groupColor);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: RaisedButton(
                      color: Color(0xFFED5AC3),
                      shape: StadiumBorder(),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () {
                        final form = formKey.currentState;
                        if (form.validate()) {
                          if (isGroup) {
                            callback(groupColor);
                          } else {
                            callback();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

showDeleteDialog({BuildContext context, Function callback, bool all}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(primarySwatch: Colors.blue),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          title: Text(
            "Are you sure you want to delete ${all ? 'all groups' : 'this group'}?",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "You cannot undo this action",
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 17.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Delete", style: TextStyle(color: Colors.red, fontSize: 17.0)),
              onPressed: callback,
            ),
          ],
        ),
      );
    },
  );
}

showAboutApp(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationIcon: Icon(Icons.copyright),
    applicationName: "Tasks App",
    applicationVersion: "1.0.0",
    children: [
      Text(
        "This is a very basic Task Management app that will help you oraginize your day and be more productive.\nHope you enjoy it :)",
      ),
    ],
  );
}
