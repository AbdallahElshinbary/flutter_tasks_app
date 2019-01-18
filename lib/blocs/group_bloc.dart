import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';
import '../resources/repository.dart';
import '../model/group.dart';

class GroupBloc implements BlocBase {
  final _repository = Repository();

  List<Group> _groups = [];

  final _groupController = BehaviorSubject<List<Group>>();

  Function(List<Group>) get sink => _groupController.sink.add;
  Observable<List<Group>> get groupStream => _groupController.stream;

  getAll() async {
    final res = await _repository.getAll('Groups');
    _groups = res.map((item) => Group.fromMap(item)).toList();
    _groupController.add(_groups);
  }

  saveGroup(Group group) async {
    group.id = await _repository.save('Groups', group);
    _groups.add(group);
    _groupController.add(_groups);
  }

  editGroup(Group newGroup) async {
    final index = _groups.indexWhere((group) => group.id == newGroup.id);
    _groups[index] = newGroup;
    await _repository.update('Groups', newGroup);
    _groupController.add(_groups);
  }

  deleteGroup(int id) async {
    await _repository.deleteGroup(id);
    _groups.removeWhere((group) => group.id == id);
    _groupController.add(_groups);
  }

  deleteAll() async {
    await _repository.deleteAll();
    _groups = [];
    _groupController.add(_groups);
  }

  dispose() {
    _groupController.close();
  }
}
