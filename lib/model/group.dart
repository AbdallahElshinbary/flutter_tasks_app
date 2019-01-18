class Group {
  int _id;
  String _name;
  int _color;

  Group(this._name, this._color);

  int get id => _id;
  String get name => _name;
  int get color => _color;

  set id(int value) => this._id = value;

  Group.fromMap(Map<String, dynamic> data)
      : this._id = data['id'],
        this._name = data['name'],
        this._color = data['color'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': _name,
      'color': _color,
    };
  }
}
