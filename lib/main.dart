import 'package:flutter/material.dart';

void main() {
  runApp(PlanManagerApp());
}

class PlanManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlanManagerScreen(),
    );
  }
}

class Plan {
  String name;
  String description;
  DateTime date;
  bool isCompleted;

  Plan({required this.name, required this.description, required this.date, this.isCompleted = false});
}

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  void _addPlan(String name, String description, DateTime date) {
    setState(() {
      plans.add(Plan(name: name, description: description, date: date));
    });
  }

  void _updatePlan(int index, String newName, String newDescription) {
    setState(() {
      plans[index].name = newName;
      plans[index].description = newDescription;
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void _deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  void _showCreatePlanDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Plan Name")),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              ElevatedButton(
                child: Text("Select Date"),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _addPlan(nameController.text, descriptionController.text, selectedDate);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plan Manager")),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onDoubleTap: () => _deletePlan(index),
            onLongPress: () {
              TextEditingController nameController = TextEditingController(text: plans[index].name);
              TextEditingController descriptionController = TextEditingController(text: plans[index].description);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Edit Plan"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(controller: nameController, decoration: InputDecoration(labelText: "Plan Name")),
                        TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updatePlan(index, nameController.text, descriptionController.text);
                          Navigator.pop(context);
                        },
                        child: Text("Update"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) => _toggleComplete(index),
              background: Container(color: Colors.green, alignment: Alignment.centerLeft, padding: EdgeInsets.all(20), child: Icon(Icons.check, color: Colors.white)),
              secondaryBackground: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.all(20), child: Icon(Icons.close, color: Colors.white)),
              child: Card(
                color: plans[index].isCompleted ? Colors.green[200] : Colors.white,
                child: ListTile(
                  title: Text(plans[index].name, style: TextStyle(decoration: plans[index].isCompleted ? TextDecoration.lineThrough : null)),
                  subtitle: Text("${plans[index].description} - ${plans[index].date.toLocal()}"),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePlanDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
