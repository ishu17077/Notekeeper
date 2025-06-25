import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notekeeper/models/note.dart';
part 'note_event.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {}
