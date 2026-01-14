import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewChatDialog extends StatefulWidget {
  const NewChatDialog({super.key});

  @override
  _NewChatDialogState createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final _formKey = GlobalKey<FormState>();
  String _chatName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Chat'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter chat name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter chat name';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _chatName = value;
            });
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _chatName);
            }
          },
          child: const Text('Create'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
