import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final repo = TaskRepository();
  final controller = TextEditingController();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await repo.getAll();
    setState(() {});
  }

  Future<void> addTask() async {

    if(controller.text.isEmpty) return;

    await repo.insert(
      Task(
        task: controller.text,
        done: 0,
        created: DateTime.now().toString(),
      ),
    );

    controller.clear();

    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await repo.delete(id);
    loadTasks();
  }

  Future<void> toggleTask(Task task) async {

    task.done = task.done == 0 ? 1 : 0;

    await repo.update(task);

    loadTasks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tarefas"),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nova tarefa",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: addTask,
            child: const Text("Adicionar"),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {

                final task = tasks[index];

                return ListTile(
                  title: Text(task.task),

                  leading: Checkbox(
                    value: task.done == 1,
                    onChanged: (_) {
                      toggleTask(task);
                    },
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteTask(task.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
