part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {}

class NoteAdd extends NoteEvent {
  Note note;
  
}
