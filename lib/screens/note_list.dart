import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/screens/note_detail.dart';
import 'package:notekeeper/state_management/note/note_bloc.dart';
import 'package:notekeeper/state_management/note_list/note_list_cubit.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  late final NoteListCubit _noteListCubit;
  late final NoteBloc _noteBloc;
  @override
  void initState() {
    // TODO: implement initState
    _noteBloc = context.read<NoteBloc>();
    _noteListCubit = context.read<NoteListCubit>();
    _noteListCubit.getNotes();
    notedialogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headlineMedium;

    return BlocBuilder<NoteListCubit, List<Note>>(builder: (context, notes) {
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Theme.of(context).primaryColor,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(notes[position].priority),
                child: getPriorityIcon(notes[position].priority),
              ),
              title: Text(
                notes[position].title,
                style: titleStyle,
              ),
              subtitle: Text(notes[position].date),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, notes[position]);
                },
              ),
              onTap: () {
                debugPrint("ListTile Tapped");
                navigateToDetail(notes[position], 'Edit Note');
              },
            ),
          );
        },
      );
    });
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;

      case 2:
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);

      case 2:
        return Icon(Icons.keyboard_arrow_right);

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    if (note.id != null) {
      _noteBloc.add(NoteEvent.deleteNote(note));

      // _showSnackBar(context, 'Note Deleted Successfully');
      // int result = await databaseHelper.deleteNote(note.id ?? 1);
      // if (result != 0) {
      //   _showSnackBar(context, 'Note Deleted Successfully');
      //   //// _noteListCubit.getNotes();
      // }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    //// if (result == true) {
    ////   _noteListCubit.getNotes();
    ////}
  }

  void notedialogs() {
    _noteBloc.stream.listen((event) {
      if (event is NoteDeleteSuccess) {
        _showSnackBar(context, "Note Delete Success");
      } else if (event is NoteAddSuccess) {
        _showSnackBar(context, "Note Added Success");
      }
    });
  }
}
