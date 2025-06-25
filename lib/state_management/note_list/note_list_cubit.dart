import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteListCubit extends Cubit<List<Note>> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  //// static NoteListCubit? _noteListCubit;
  List<Note> notes = [];
  NoteListCubit() : super([]);
  //// NoteListCubit._createState() : super([]);
  //// factory NoteListCubit() {
  ////   if (_noteListCubit == null) {
  ////     _noteListCubit = NoteListCubit._createState();
  ////   }
  ////   return _noteListCubit!;
  //// }

  Future<void> deleteNote(Note note) async {
    List<Note> notes = List.from(this.state);
    if (notes.isEmpty || note.id == null) {
      return;
    }

    notes.removeWhere((Note noteIter) {
      return note.id == noteIter.id;
    });
    emit(notes);
  }

  Future<void> addNote(Note note) async {
    if (note.id == null) {
      return;
    }
    List<Note> notes = List.from(this.state);
    if (note.priority == 1) {
      notes.insert(0, note);
    } else {
      notes.add(note);
    }
    emit(notes);
  }

  Future<void> getNotes() async {
    notes = await _databaseHelper.getNoteList();
    emit(notes);
  }
}
