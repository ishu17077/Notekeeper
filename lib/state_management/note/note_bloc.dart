import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/state_management/note_list/note_list_cubit.dart';
import 'package:notekeeper/utils/database_helper.dart';
part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  late final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NoteListCubit _noteListCubit;

  NoteBloc(this._noteListCubit) : super(NoteInitial()) {
    on<NoteAdd>((NoteAdd event, Emitter<NoteState> emit) async {
      emit(NoteLoading(event.note));
      int noteId = (await _databaseHelper.insertNote(event.note));
      if (noteId != 0) {
        _noteListCubit.addNote(Note.withId(noteId, event.note.title,
            event.note.date, event.note.priority, event.note.description));
        emit(NoteState.noteAdded(event.note));

        // _noteListCubit.getNotes();
        return;
      }
      emit(NoteAddFailed(event.note));
    });

    on<NoteDelete>((event, emit) async {
      emit(NoteLoading(event.note));
      if (event.note.id == null) {
        emit(NoteDeleteFailed(event.note));
        return;
      }

      if ((await _databaseHelper.deleteNote(event.note.id!)) != 0) {
        _noteListCubit.deleteNote(event.note);
        emit(NoteState.noteDeleted(event.note));

        // _noteListCubit.getNotes();
        return;
      }
      emit(NoteDeleteFailed(event.note));
    });
    on<NoteUpdate>((event, emit) async {
      emit(NoteLoading(event.note));
      if (event.note.id == null) {
        emit(NoteDeleteFailed(event.note));
        return;
      }
      int result = await _databaseHelper.updateNote(event.note);
      if (result != 0) {
        emit(NoteUpdateSuccess(event.note));
        return;
      }
      emit(NoteUpdateFailed(event.note));
    });
  }
}
