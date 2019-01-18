import 'package:rxdart/rxdart.dart';
import 'bloc_provider.dart';
import '../resources/repository.dart';
import '../model/task.dart';

class TaskBloc implements BlocBase {
  final _repository = Repository();

  List<Task> _tasks = [];

  final _taskController = BehaviorSubject<List<Task>>();

  Function(List<Task>) get sink => _taskController.sink.add;
  Observable<List<Task>> get taskStream => _taskController.stream;

  getAll() async {
    final res = await _repository.getAll('Tasks'); 
    _tasks = res.map((item) => Task.fromMap(item)).toList();
    _taskController.add(_tasks);
  }

  saveTask(Task task) async {
    task.id = await _repository.save('Tasks', task);
    _tasks.add(task);
    _taskController.add(_tasks);
  }

  markTask(Task oldTask) async {
    Task newTask = Task.fromMap({
      'id': oldTask.id,
      'title': oldTask.title,
      'done': oldTask.done ? 0 : 1,
      'groupId': oldTask.groupId,
    });
    final index = _tasks.indexWhere((task) => task.id == oldTask.id);
    _tasks[index] = newTask;
    await _repository.update('Tasks', newTask);
    _taskController.add(_tasks);
  }

  deleteTask(int id) async {
    await _repository.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    _taskController.add(_tasks);
  }

  dispose() {
    _taskController.close();
  }
}
