class Task {
  int _id;
  String _title;
  bool _done; 
  int _groupId;

  Task(this._title, this._done, this._groupId);

  int get id => _id;
  String get title => _title;
  bool get done => _done;
  int get groupId => _groupId;

  set id(int value) => this._id = value;

  Task.fromMap(Map<String, dynamic> data)
      : this._id = data['id'],
        this._title = data['title'],
        this._done = data['done'] == 1,
        this._groupId = data['groupId'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': _title,
      'done': _done ? 1 : 0,
      'groupId': _groupId,
    };
  }
}
