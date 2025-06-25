import 'package:bloc/bloc.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteListCubit extends Cubit<List<Note>> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static NoteListCubit? _noteListCubit;
  NoteListCubit._createState() : super([]);

  factory NoteListCubit() {
    if (_noteListCubit == null) {
      _noteListCubit = NoteListCubit._createState();
    }
    return _noteListCubit!;
  }

  Future<void> getNotes() async {
    final List<Note> notes = await _databaseHelper.getNoteList();
    emit(notes);
  }
}
