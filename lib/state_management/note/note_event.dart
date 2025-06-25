part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  factory NoteEvent.addNote(Note note) => NoteAdd(note);
  factory NoteEvent.deleteNote(Note note) => NoteDelete(note);
  @override
  List<Note> get props => [];
}

class NoteAdd extends NoteEvent {
  final Note note;
  const NoteAdd(this.note);

  @override
  List<Note> get props => [note];
}

class NoteUpdate extends NoteEvent {
  final Note note;
  const NoteUpdate(this.note);

  @override
  // TODO: implement props
  List<Note> get props => [note];
}

class NoteDelete extends NoteEvent {
  final Note note;
  const NoteDelete(this.note);

  @override
  List<Note> get props => [note];
}
