import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
        child: Column(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: SvgPicture.asset("assets/images/beach.svg"),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "No Tasks",
              style: TextStyle(color: Colors.blueGrey, fontSize: 30.0),
            ),
          ],
        ),
      ),
    );
  }
}
