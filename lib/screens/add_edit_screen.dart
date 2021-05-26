import 'package:flutter/material.dart';
import 'package:todos/models/todo.dart';

//typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatefulWidget {
  static const nom = '/AddEditScreen';

  final bool isEditing;
  final Todo todo;

  AddEditScreen({
    @required this.isEditing,
    this.todo,
  });

  @override
  AddEditScreenState createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _task;
  String _note;
  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit' : 'Add'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _taskField(context),
              _noteField(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.of(context).pop({
              'task': _task,
              'note': _note,
            });
          }
        },
      ),
    );
  }

  TextFormField _taskField(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      initialValue: isEditing ? widget.todo.task : '',
      autofocus: !isEditing,
      style: textTheme.headline5,
      validator: (value) => value.trim().isEmpty ? 'Camp obligatori' : null,
      onSaved: (value) => _task = value,
    );
  }

  TextFormField _noteField(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      initialValue: isEditing ? widget.todo.note : '',
      maxLines: 10,
      style: textTheme.subtitle1,
      onSaved: (value) => _note = value,
    );
  }
}
