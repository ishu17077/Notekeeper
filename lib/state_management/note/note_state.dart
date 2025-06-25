part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  factory NoteState.initial() => NoteInitial();
  factory NoteState.noteAdded(Note note) => NoteAddSuccess(note);
  factory NoteState.noteDeleted(Note note) => NoteDeleteSuccess(note);

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {
  final Note note;
  const NoteLoading(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteAddSuccess extends NoteState {
  final Note note;
  const NoteAddSuccess(this.note);
  @override
  List<Object?> get props => [note];
}

class NoteUpdateSuccess extends NoteState {
  final Note note;
  const NoteUpdateSuccess(this.note);
  @override
  List<Object?> get props => [note];
}

class NoteUpdateFailed extends NoteState {
  final Note note;
  const NoteUpdateFailed(this.note);
  @override
  List<Object?> get props => [note];
}

class NoteDeleteSuccess extends NoteState {
  final Note note;
  const NoteDeleteSuccess(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteAddFailed extends NoteState {
  final Note note;
  const NoteAddFailed(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteDeleteFailed extends NoteState {
  final Note note;
  const NoteDeleteFailed(this.note);

  @override
  List<Object?> get props => [note];
}
