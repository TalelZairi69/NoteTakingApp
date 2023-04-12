import 'package:flutter/material.dart';
import 'note.dart';
import 'note_card.dart';
import 'note_details_screen.dart';
import 'new_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notesList = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadNotes();
  }

  void _loadNotes() async {
    final notes = await Note.getAll();
    setState(() {
      _notesList = notes;
    });
  }

  void _navigateToNewNoteScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const NewNoteScreen(),
      ),
    );
    if (result == true) {
      _loadNotes();
    }
  }

  void _navigateToNoteDetailsScreen(BuildContext context, int index) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => NoteDetailsScreen(
          note: _notesList[index],
        ),
      ),
    );
    if (result == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notesList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _navigateToNoteDetailsScreen(context, index);
            },
            child: NoteCard(note: _notesList[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToNewNoteScreen(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
