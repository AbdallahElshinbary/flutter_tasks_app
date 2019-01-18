import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _length = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _length,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Page(
                    title: "keep Organized",
                    description:
                        "This simple app keep your ideas and tasks orgainized in one place, It saves you from headaches.",
                    image: "task.png",
                    last: false,
                  ),
                  Page(
                    title: "Group Tasks",
                    description: "Group your related tasks together so you never get lost in the mess.",
                    image: "group.png",
                    last: false,
                  ),
                  Page(
                    title: "Be Productive",
                    description: "Increase your productivity and save your mind from remembering more tasks.",
                    image: "productive.png",
                    last: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Theme(
                data: Theme.of(context).copyWith(accentColor: Color(0xFF951FF4)),
                child: TabPageSelector(
                  controller: _tabController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool last;

  const Page({
    Key key,
    this.title,
    this.description,
    this.image,
    this.last,
  }) : super(key: key);

  Widget _buildText(BuildContext context, bool last) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.blueGrey[400], fontSize: 50.0, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          description,
          style: TextStyle(color: Colors.blueGrey[300], fontSize: 20.0, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
        !last ? Container() : _buildButton(context),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: RaisedButton(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/");
        },
        child: Text(
          "GET STARTED",
          style: TextStyle(color: Color(0xFF951FF4), fontSize: 20.0),
        ),
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30),
        Container(height: 300.0, child: Image.asset("assets/images/$image")),
        _buildText(context, last),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 300,
          child: Image.asset("assets/images/$image"),
        ),
        Flexible(child: _buildText(context, last)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: MediaQuery.of(context).size.width > 600 ? _buildLandscape(context) : _buildPortrait(context),
    );
  }
}
