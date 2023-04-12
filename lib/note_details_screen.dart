import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'note.dart';
import 'new_note_screen.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note note;

  const NoteDetailsScreen({required this.note});

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  Color _currentColor = Colors.white;

  void _editNote() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => NewNoteScreen(
          note: widget.note,
        ),
      ),
    );
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  void _deleteNote() async {
    await widget.note.delete();
    Navigator.of(context).pop(true);
  }

  void _changeColor(Color color) {
    setState(() {
      _currentColor = color;
    });
    // Save the color to the database
    widget.note.color = color.value;
    widget.note.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: _currentColor,
                        onColorChanged: _changeColor,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: () {
              // Implement reminder logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editNote,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat.yMd().add_jm().format(DateTime.parse(widget.note.date))}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              widget.note.content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
